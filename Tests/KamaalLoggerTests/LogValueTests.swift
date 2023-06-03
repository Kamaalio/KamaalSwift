//
//  LogValueTests.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import XCTest
@testable import KamaalLogger

final class LogValueTests: XCTestCase {
    var logger: KamaalLogger!

    override func setUpWithError() throws {
        let holder = LogHolder(max: max(LogLevels.allCases.count, 3))
        logger = .init(subsystem: "io.kamaal.Testing", from: LogValueTests.self, holder: holder)
    }

    func testLogValue() async throws {
        @LogValue(description: "Hello", logger: logger, level: .info)
        var value = "Value"

        let initialLog = try await getLog(from: logger)
        XCTAssertEqual(initialLog.message, "Initialized 'Hello'; value='Value'")

        XCTAssertEqual(value, "Value")
        let accessLog = try await getLog(from: logger, at: 1)
        XCTAssertEqual(accessLog.message, "Accessing 'Hello'; value='Value'")

        value = "Something Else"
        XCTAssertEqual(value, "Something Else")
        let updateLog = try await getLog(from: logger, at: 2)
        XCTAssertEqual(updateLog.message, "Updating 'Hello'; value='Value'")
    }

    func testLogLevels() async throws {
        for (index, level) in LogLevels.allCases.enumerated() {
            @LogValue(description: "Level Things", logger: logger, level: level)
            var value: String = level.rawValue

            let log = try await getLog(from: logger, at: index)
            XCTAssertEqual(log.message, "Initialized 'Level Things'; value='\(level.rawValue)'")
            XCTAssertEqual(log.level, level)
        }
    }
}
