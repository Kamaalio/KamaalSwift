//
//  KamaalLoggerTests.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import XCTest
@testable import KamaalLogger
import CwlPreconditionTesting

final class KamaalLoggerTests: XCTestCase {
    var logger: KamaalLogger!

    override func setUpWithError() throws {
        let holder = LogHolder(max: 1)
        self.logger = .init(subsystem: "io.kamaal.Testing", from: KamaalLoggerTests.self, holder: holder)
    }

    func testStructuredFieldsPreserveOrderAndDefaultToPrivate() async throws {
        let fields: [LogField] = [
            .init("status", "cached=1; retry=false", privacy: .public),
            .init("internal_context", "internal diagnostic"),
            .init("status", "fresh", privacy: .public),
        ]

        self.logger.info("Collection loaded", fields: fields)

        let entry = try await getLog(from: self.logger)
        XCTAssertEqual(entry.message, "Collection loaded")
        XCTAssertEqual(entry.fields(), [fields[0], fields[2]])
        XCTAssertEqual(entry.fields(includingPrivate: true), fields)
    }

    func testEncodableFieldPreservesNestedJSON() async throws {
        struct Snapshot: Codable, Equatable {
            struct Page: Codable, Equatable {
                let cardNames: [String]
            }

            let pages: [Page]
            let isCached: Bool
        }

        let snapshot = Snapshot(pages: [.init(cardNames: ["A=B; C"])], isCached: true)
        let field = LogField("snapshot", object: snapshot)
        self.logger.info("Loaded", fields: [field])

        let entry = try await getLog(from: self.logger)
        XCTAssertTrue(entry.fields().isEmpty)
        let fallback = try XCTUnwrap(entry.jsonObjects().first)
        XCTAssertEqual(try JSONDecoder().decode([String: String].self, from: fallback), ["message": "Loaded"])
        let value = try XCTUnwrap(entry.fields(includingPrivate: true).first?.value)
        guard case let .json(data) = value else {
            return XCTFail("Expected a JSON field")
        }
        XCTAssertEqual(try JSONDecoder().decode(Snapshot.self, from: data), snapshot)
        XCTAssertEqual(value.displayText, String(decoding: data, as: UTF8.self))
    }

    func testInvalidEncodableFieldCapturesOnlyAFailureMarker() async throws {
        let field = LogField("measurement", object: Double.infinity, privacy: .public)
        self.logger.warning("Invalid measurement", fields: [field])

        let entry = try await getLog(from: self.logger)
        XCTAssertEqual(entry.message, "Invalid measurement")
        XCTAssertEqual(entry.fields().first?.value, .encodingFailed)
    }

    func testJSONObjectsFallBackToTheOriginalMessage() async throws {
        let message = "Collection loaded; result=one\nCards: \"A=B; C\""
        self.logger.info(message)

        let entry = try await getLog(from: self.logger)
        let objects = try entry.jsonObjects()
        XCTAssertEqual(objects.count, 1)
        let object = try XCTUnwrap(objects.first)
        XCTAssertEqual(try JSONDecoder().decode([String: String].self, from: object), ["message": message])
    }

    func testJSONObjectsHonorPrivacyAndFieldOrder() async throws {
        self.logger.info("Collection loaded", fields: [
            .init("page", object: ["count": 1], privacy: .public),
            .init("between", "text", privacy: .public),
            .init("private_page", object: ["count": 2]),
            .init("page", object: ["count": 3], privacy: .public),
        ])

        let entry = try await getLog(from: self.logger)
        let visible = try entry.jsonObjects().map { try JSONDecoder().decode([String: Int].self, from: $0) }
        XCTAssertEqual(visible, [["count": 1], ["count": 3]])
        let all = try entry.jsonObjects(includingPrivate: true).map {
            try JSONDecoder().decode([String: Int].self, from: $0)
        }
        XCTAssertEqual(all, [["count": 1], ["count": 2], ["count": 3]])
    }

    func testLoggingIsImmediatelyVisibleInInsertionOrder() async {
        let holder = LogHolder(max: 2)
        let logger = KamaalLogger(label: "Ordering", holder: holder)

        logger.info("Evicted")
        logger.warning("First", fields: [.init("source", "cache", privacy: .public)])
        logger.error("Second")

        let entries = await holder.logs
        XCTAssertEqual(entries.map(\.message), ["First", "Second"])
        XCTAssertEqual(entries.map(\.level), [.warning, .error])
        XCTAssertEqual(entries.last?.fields(), [])
    }

    func testConcurrentLoggingCapturesEachEntry() async {
        let holder = LogHolder(max: nil)
        let logger = KamaalLogger(label: "Concurrent", holder: holder)
        let messages = (0 ..< 64).map { "Entry \($0)" }

        await withTaskGroup(of: Void.self) { group in
            for message in messages {
                group.addTask { logger.info(message) }
            }
        }

        let entries = await holder.logs.map(\.message)
        XCTAssertEqual(entries.sorted(), messages.sorted())
    }

    func testNonpositiveCapacityDisablesCapture() async {
        let holder = LogHolder(max: 0)
        let logger = KamaalLogger(label: "Disabled", holder: holder)

        logger.info("Console only")

        let entries = await holder.logs
        XCTAssertTrue(entries.isEmpty)
    }

    func testStructuredDebugFollowsBuildConfiguration() async {
        let holder = LogHolder()
        let logger = KamaalLogger(label: "Debug", holder: holder)
        let field = LogField("diagnostic", "private detail")

        logger.debug("Debug detail", fields: [field])

        let entries = await holder.logs
        #if DEBUG
        XCTAssertEqual(entries.map(\.level), [.debug])
        XCTAssertEqual(entries.first?.fields(includingPrivate: true), [field])
        #else
        XCTAssertTrue(entries.isEmpty)
        #endif
    }

    func testErrorLogged() async throws {
        let label = "Oh No!"
        let error = TestError.test

        self.logger.error(label: label, error: error)

        let log = try await getLog(from: logger)
        XCTAssert(log.message.contains(label))
        XCTAssert(log.message.contains(error.localizedDescription))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.level, .error)
        XCTAssertEqual(log.level.color, .red)
    }

    func testErrorLoggedAndFail() {
        let logger = KamaalLogger(from: KamaalLoggerTests.self, failOnError: true)

        XCTAssertNotNil(catchBadInstruction { logger.error(label: "Fail harshly", error: TestError.test) })
    }

    func testWarningLogged() async throws {
        let message1 = "Oh well! 🤷"
        let message2 = "Go on as usual"

        self.logger.warning(message1, message2)

        let log = try await getLog(from: logger)
        XCTAssert(log.message.contains(message1))
        XCTAssert(log.message.contains(message2))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.level, .warning)
        XCTAssertEqual(log.level.color, .yellow)
    }

    func testInfoLogged() async throws {
        let message1 = "Phew!"
        let message2 = "Run Forest Run"

        self.logger.info(message1, message2)

        let log = try await getLog(from: logger)
        XCTAssert(log.message.contains(message1))
        XCTAssert(log.message.contains(message2))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.level, .info)
        XCTAssertEqual(log.level.color, .green)
    }

    func testDebugLogged() async throws {
        let message = "What are thoooose"

        self.logger.debug(message)

        let log = try await getLog(from: logger)
        XCTAssert(log.message.contains(message))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.level, .debug)
        XCTAssertEqual(log.level.color, .gray)
    }
}
