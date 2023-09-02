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

    func testErrorLoggedAndFail() async throws {
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
