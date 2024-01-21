//
//  RetrierTests.swift
//
//
//  Created by Kamaal M Farah on 21/01/2024.
//

import XCTest
import Foundation
import KamaalUtils

final class RetrierTests: XCTestCase {
    func testSucceedsAfter2Retries() async throws {
        var tries = 0
        let goal = 2
        func retryingThrowingFunction() throws {
            if tries >= goal {
                return
            }
            tries += 1
            throw Errors.testError
        }

        try await Retrier.retryUntilSuccess(intervalTimeInSeconds: 1, completion: retryingThrowingFunction)

        XCTAssertEqual(tries, goal)
    }
}

private enum Errors: Error {
    case testError
}
