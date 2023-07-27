//
//  IntTests.swift
//
//
//  Created by Kamaal M Farah on 27/07/2023.
//

import XCTest
import KamaalExtensions

final class IntTests: XCTestCase {
    func testIntAsInt64() {
        XCTAssertEqual(420.int64, 420)
    }

    func testIntAsNSNumber() {
        XCTAssertEqual(420.nsNumber, 420)
    }

    func testIntAsString() {
        XCTAssertEqual(420.string, "420")
    }
}
