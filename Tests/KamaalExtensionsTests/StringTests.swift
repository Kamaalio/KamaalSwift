//
//  StringTests.swift
//
//
//  Created by Kamaal M Farah on 07/08/2021.
//

import XCTest
@testable import KamaalExtensions

class StringTests: XCTestCase { }

// - MARK: localizedStringToDouble

extension StringTests {
    func testLocalizedStringToDouble() throws {
        let cases = [
            ("0,213114", 0.213114),
            ("1.154,74", 1154.74),
            ("420", 420),
            ("4.20", 4.2),
            ("4,20", 4.2),
        ]
        for (input, expectedResult) in cases {
            let result = try XCTUnwrap(input.localizedStringToDouble)
            XCTAssertEqual(result, expectedResult)
        }
    }
}

// - MARK: int

extension StringTests {
    func testInt() {
        let cases: [(String, Int?)] = [
            ("1", 1),
            ("one", nil),
            ("", nil),
            ("l337", nil),
            ("420", 420),
        ]
        for (input, expected) in cases {
            XCTAssertEqual(input.int, expected)
        }
    }
}

// - MARK: splitByCapital

extension StringTests {
    func testSplitByCapital() {
        let testCase = "IAmSuperCool".splitByCapital
        XCTAssertEqual(testCase.count, 4)
        let expectedResult = ["I", "Am", "Super", "Cool"]
        XCTAssertEqual(testCase, expectedResult)
    }
}

// - MARK: splitLines

extension StringTests {
    func testSplitLines() {
        let cases: [(String, [String])] = [
            ("\n\n", []),
            ("\ni\n", ["i"]),
            ("", []),
            ("hi\nno", ["hi", "no"]),
        ]
        for (input, expected) in cases {
            XCTAssertEqual(input.splitLines.map { String($0) }, expected)
        }
    }
}

// - MARK: splitCommas

extension StringTests {
    func testSplitCommas() {
        let cases: [(String, [String])] = [
            (",,", []),
            (",i,", ["i"]),
            ("", []),
            ("hi,no", ["hi", "no"]),
        ]
        for (input, expected) in cases {
            XCTAssertEqual(input.splitCommas.map { String($0) }, expected)
        }
    }
}

// - MARK: trimmingByWhitespacesAndNewLines

extension StringTests {
    func testTrimmingByWhitespacesAndNewLines() {
        let testCase = " I am super cool ".trimmingByWhitespacesAndNewLines
        let expectedResult = "I am super cool"
        XCTAssertEqual(testCase, expectedResult)
    }
}

// - MARK: nsString

extension StringTests {
    func testNSString() {
        XCTAssertNotNil("nstring".nsString)
    }
}

// - MARK: uuid

extension StringTests {
    func testUUID() {
        XCTAssertNil("not a uuid".uuid)
        XCTAssertNotNil("26e92a7d-b958-4106-8372-c1cceed40b1f".uuid)
    }
}

// - MARK: scrambled

extension StringTests {
    func testScrambled() {
        let original = "original"
        let scrambled = original.scrambled
        XCTAssertEqual(original.count, scrambled.count)
    }
}

// - MARK: digits

extension StringTests {
    func testDigits() {
        let testCase = "Cool story 4 the 2 foxes with 0 carrots".digits
        let expectedResult = "420"
        XCTAssertEqual(testCase, expectedResult)
    }
}

// - MARK: replaceMultipleOccurrences

extension StringTests {
    func testReplaceMultipleOccurrences() {
        let testCase = "yes 22".replaceMultipleOccurrences(of: ["e", "s"], with: "a")
        let expectedResult = "yaa 22"
        XCTAssertEqual(testCase, expectedResult)
    }

    func testReplaceMultipleOccurrencesWithNoTargets() {
        let testCase = "yes 22".replaceMultipleOccurrences(of: [], with: "a")
        let expectedResult = "yes 22"
        XCTAssertEqual(testCase, expectedResult)
    }

    func testReplaceMultipleOccurrencesWithNoMatchingTargets() {
        let testCase = "yes 22".replaceMultipleOccurrences(of: ["z", "k"], with: "a")
        let expectedResult = "yes 22"
        XCTAssertEqual(testCase, expectedResult)
    }
}

// - MARK: subscript

extension StringTests {
    func testSubscript() {
        let character = "Hallo"[0]
        let expectedResult = Character("H")
        XCTAssertEqual(character, expectedResult)
    }
}

// - MARK: range

extension StringTests {
    func testRange() {
        let range = "Between the $dollar signs$ yes!".range(from: 13, to: 25)
        XCTAssertEqual(range, "dollar signs")
    }

    func testRangeDefaultEnd() {
        let range = "How cool am I?".range(from: 4)
        XCTAssertEqual(range, "cool am I?")
    }

    func testRangeLateEnd() {
        let range = "Cut early".range(from: 1, to: 100)
        XCTAssertEqual(range, "ut early")
    }
}
