//
//  SequenceTests.swift
//
//
//  Created by Kamaal M Farah on 24/12/2021.
//

import XCTest
@testable import KamaalExtensions

final class SequenceTests: XCTestCase { }

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
