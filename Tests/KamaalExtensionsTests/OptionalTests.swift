//
//  OptionalTests.swift
//
//
//  Created by Kamaal M Farah on 24/12/2021.
//

import XCTest
@testable import KamaalExtensions

final class OptionalTests: XCTestCase { }

// - MARK: findIndex

extension OptionalTests {
    func testAdd() {
        let cases: [(Int?, Int?)] = [
            (22, 44),
            (nil, nil),
        ]
        for (numberToAdd, expectedResult) in cases {
            var mutNumberToAdd = numberToAdd
            mutNumberToAdd.add(22)
            XCTAssertEqual(mutNumberToAdd, expectedResult)
        }
    }
}
