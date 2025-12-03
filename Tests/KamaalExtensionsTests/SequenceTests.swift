//
//  SequenceTests.swift
//
//
//  Created by Kamaal M Farah on 24/12/2021.
//

import XCTest

@testable import KamaalExtensions

final class SequenceTests: XCTestCase { }

// - MARK: chunked

extension SequenceTests {
    func testChunkedWithExactDivision() {
        let numbers = [1, 2, 3, 4, 5, 6]
        let result = numbers.chunked(2)
        XCTAssertEqual(result, [[1, 2], [3, 4], [5, 6]])
    }

    func testChunkedWithRemainder() {
        let numbers = [1, 2, 3, 4, 5]
        let result = numbers.chunked(2)
        XCTAssertEqual(result, [[1, 2], [3, 4], [5]])
    }

    func testChunkedWithoutRemainder() {
        let numbers = [1, 2, 3, 4, 5]
        let result = numbers.chunked(2, includeRemainder: false)
        XCTAssertEqual(result, [[1, 2], [3, 4]])
    }

    func testChunkedWithEmptyArray() {
        let numbers: [Int] = []
        let result = numbers.chunked(2)
        XCTAssertEqual(result, [])
    }

    func testChunkedWithChunkSizeLargerThanArray() {
        let numbers = [1, 2, 3]
        let result = numbers.chunked(10)
        XCTAssertEqual(result, [[1, 2, 3]])
    }

    func testChunkedWithChunkSizeLargerThanArrayWithoutRemainder() {
        let numbers = [1, 2, 3]
        let result = numbers.chunked(10, includeRemainder: false)
        XCTAssertEqual(result, [])
    }

    func testChunkedWithChunkSizeOfOne() {
        let numbers = [1, 2, 3]
        let result = numbers.chunked(1)
        XCTAssertEqual(result, [[1], [2], [3]])
    }
}

// - MARK: find

extension SequenceTests {
    func testFindWithKeyPath() {
        let equatableArray: [SomeEquatableObject] = [
            .init(foo: false, bar: 0),
            .init(foo: false, bar: 1),
            .init(foo: true, bar: 2),
            .init(foo: false, bar: 3),
        ]
        let result = equatableArray.find(by: \.foo, is: true)
        XCTAssertEqual(result, SomeEquatableObject(foo: true, bar: 2))
    }

    func testCouldNotFindWithKeyPath() {
        let equatableArray: [SomeEquatableObject] = [
            .init(foo: false, bar: 0),
            .init(foo: false, bar: 1),
            .init(foo: false, bar: 2),
            .init(foo: false, bar: 3),
        ]
        let result = equatableArray.find(by: \.bar, is: 4)
        XCTAssertNil(result)
    }

    private struct SomeEquatableObject: Equatable {
        let foo: Bool
        let bar: Int
    }
}
