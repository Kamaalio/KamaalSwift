//
//  KamaalLoggerTests.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import XCTest
@testable import KamaalLogger

final class KamaalLoggerTests: XCTestCase {
    var logger: KamaalLogger!

    override func setUpWithError() throws {
        let holder = LogHolder(max: 1)
        logger = .init(subsystem: "io.kamaal.Testing.One", from: KamaalLoggerTests.self, holder: holder)
    }

    func testErrorLogged() async throws {
        let label = "Oh No!"
        let error = TestError.test
        logger.error(label: label, error: error)

        let log = try await getLog()
        XCTAssert(log.message.contains(label))
        XCTAssert(log.message.contains(error.localizedDescription))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.type, .error)
        XCTAssertEqual(log.type.color, .red)
    }

    func testWarningLogged() async throws {
        let message1 = "Oh well! 🤷"
        let message2 = "Go on as usual"
        logger.warning(message1, message2)

        let log = try await getLog()
        XCTAssert(log.message.contains(message1))
        XCTAssert(log.message.contains(message2))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.type, .warning)
        XCTAssertEqual(log.type.color, .yellow)
    }

    func testInfoLogged() async throws {
        let message1 = "Phew!"
        let message2 = "Run Forest Run"
        logger.info(message1, message2)

        let log = try await getLog()
        XCTAssert(log.message.contains(message1))
        XCTAssert(log.message.contains(message2))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.type, .info)
        XCTAssertEqual(log.type.color, .green)
    }

    func testDebugLogged() async throws {
        let message = "What are thoooose"
        logger.debug(message)

        let log = try await getLog()
        XCTAssert(log.message.contains(message))
        XCTAssertEqual(log.label, String(describing: KamaalLoggerTests.self))
        XCTAssertEqual(log.type, .debug)
        XCTAssertEqual(log.type.color, .gray)
    }

    private func getLog() async throws -> HoldedLog {
        var log: HoldedLog?
        let timeoutDate = Date(timeIntervalSinceNow: 0.5)
        repeat {
            log = await logger.holder?.logs.first
        } while log == nil && Date().compare(timeoutDate) == .orderedAscending

        guard let log else { throw TestError.test }

        return log
    }
}

enum TestError: LocalizedError {
    case test

    public var errorDescription: String? {
        "something horrible happened"
    }
}
