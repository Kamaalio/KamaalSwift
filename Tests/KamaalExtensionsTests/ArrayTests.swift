//
//  ArrayTests.swift
//
//
//  Created by Kamaal M Farah on 24/12/2021.
//

import Testing
import Foundation
import KamaalExtensions

// - MARK: removed

@Test("Removes given element", arguments: [
    ([0, 1], [1], 0),
    ([], [], 2),
    ([1], [1], 1),
    ([1], [], 0),
])
func removesGivenElement(input: [Int], expectedResult: [Int], elementIndexToRemove: Int) {
    #expect(input.removed(at: elementIndexToRemove) == expectedResult)
}

// - MARK: ranged

@Test("Ranges array", arguments: [
    ([0, 1, 2], 0, 3, [0, 1, 2]),
    ([0, 1, 2], 1, 3, [1, 2]),
    ([0, 1, 2], 0, 4, [0, 1, 2]),
    ([0, 1, 2], 4, 4, []),
    ([0, 1, 2], 10, 3, []),
])
func rangesArray(array: [Int], start: Int, end: Int, expectedArray: [Int]) {
    #expect(array.ranged(from: start, to: end).asArray() == expectedArray)
}

// - MARK: map

private let mapsAndLimitsUntilPredicateArguments: [([Int], Character, [Character])] = [
    ([0, 1, 2], "2", ["0", "1", "2"]),
    ([0, 1, 2], "1", ["0", "1"]),
    ([0, 1, 2], "9", ["0", "1", "2"]),
]

@Test("Maps and limits until predicate", arguments: mapsAndLimitsUntilPredicateArguments)
func mapsAndLimitsUntilPredicate(_ array: [Int], _ limit: Character, _ expectedArray: [Character]) {
    let array = array.map({ Character(String($0)) }, until: { $0 == limit })

    #expect(array == expectedArray)
}

// - MARK: uniques

@Test("Keeps only unique elements", arguments: [
    ([0, 1, 2], [0, 1, 2]),
    ([0, 1, 1, 2], [0, 1, 2]),
])
func keepsOnlyUniqueElements(array: [Int], expectedArray: [Int]) {
    #expect(array.uniques() == expectedArray)
}

// - MARK: appended

@Test("Appends element to array")
func appendsElementToArray() {
    let array = [0, 1, 2]

    #expect(array.appended(3) == [0, 1, 2, 3])
}

// - MARK: removedLast

@Test("Removes last element in array")
func removesLastElementInArray() {
    let array = [0, 1, 2]

    #expect(array.removedLast() == [0, 1])
}

@Test("Doesn't do anything because array is already empty")
func doesntDoAnythingBecauseArrayIsAlreadyEmpty() {
    let array: [Int] = []

    #expect(array.removedLast().isEmpty)
}

// - MARK: asNSSet

@Test("Transforms array to an NSSet")
func transformsArrayToAnNSSet() {
    let array = [0, 1, 2]

    #expect(array.asNSSet == NSSet(array: [0, 1, 2]))
}

// - MARK: prepended

@Test("Prepended to an array")
func prependedToAnArray() {
    let array = [0, 1, 2]

    #expect(array.prepended(-1) == [-1, 0, 1, 2])
}

// - MARK: prepend

@Test("Prepends to an array")
func prependsToAnArray() {
    var array = [0, 1, 2]

    array.prepend(-1)

    #expect(array == [-1, 0, 1, 2])
}

// - MARK: concat

@Test("Concatenates 2 arrays together", arguments: [
    ([1, 2], [3, 4], [1, 2, 3, 4]),
    ([], [1, 2], [1, 2]),
    ([1, 2], [], [1, 2]),
])
func concatenatesTwoArraysTogether(firstArray: [Int], secondArray: [Int], result: [Int]) {
    #expect(firstArray.concat(secondArray) == result)
}

// - MARK: toSet

@Test("Transforms array to set", arguments: [
    ([1, 2, 2], Set([1, 2])),
    ([1, 2, 3], Set([1, 2, 3])),
])
func transformsArrayToSet(input: [Int], expectedResult: Set<Int>) {
    #expect(input.toSet == expectedResult)
}

// - MARK: at

@Test("Gets element with given index", arguments: [
    (0, 0),
    (1, 1),
    (2, 2),
    (-1, 2),
    (-2, 1),
    (-3, 0),
])
func getsElementWithGivenIndex(index: Int, element: Int) {
    let arr = (0 ..< 3).asArray()

    #expect(arr.at(index) == element)
}

@Test("Fails to get given element because index is out of range", arguments: [
    -4,
    3,
])
func failsToGetGivenElementBecauseIndexIsOutOfRange(index: Int) {
    let arr = (0 ..< 3).asArray()

    #expect(arr.at(index) == nil)
}

// - MARK: findIndex

@Test("Finds the index with a key path")
func findsTheIndexWithAKeyPath() {
    let equatableArray: [SomeEquatableObject] = [
        .init(foo: false, bar: 0),
        .init(foo: false, bar: 1),
        .init(foo: true, bar: 2),
        .init(foo: false, bar: 3),
    ]

    let result = equatableArray.findIndex(by: \.foo, is: true)

    #expect(result == 2)
}

@Test("Could not find index with a key path")
func couldNotFindIndexWithAKeyPath() {
    let equatableArray: [SomeEquatableObject] = [
        .init(foo: false, bar: 0),
        .init(foo: false, bar: 1),
        .init(foo: false, bar: 2),
        .init(foo: false, bar: 3),
    ]

    let result = equatableArray.findIndex(by: \.bar, is: 4)

    #expect(result == nil)
}

// - MARK: sorted

@Test("Sorts by order ascending")
func sortsByOrderAscending() {
    let equatableArray: [SomeEquatableObject] = [
        .init(foo: false, bar: 10),
        .init(foo: false, bar: 4),
        .init(foo: false, bar: 0),
        .init(foo: false, bar: 8),
    ]

    #expect(equatableArray.sorted(by: \.bar, using: .orderedAscending).map(\.bar) == [0, 4, 8, 10])
}

@Test("Sorts by order descending")
func sortsByOrderDescending() {
    let equatableArray: [SomeEquatableObject] = [
        .init(foo: false, bar: 10),
        .init(foo: false, bar: 4),
        .init(foo: false, bar: 0),
        .init(foo: false, bar: 8),
    ]

    #expect(equatableArray.sorted(by: \.bar, using: .orderedDescending).map(\.bar) == [10, 8, 4, 0])
}

@Test("Sorts by order same")
func sortsByOrderSame() {
    let equatableArray: [SomeEquatableObject] = [
        .init(foo: false, bar: 10),
        .init(foo: false, bar: 4),
        .init(foo: false, bar: 0),
        .init(foo: false, bar: 8),
    ]

    #expect(equatableArray.sorted(by: \.bar, using: .orderedSame).map(\.bar) == [10, 4, 0, 8])
}

private struct SomeEquatableObject: Equatable {
    let foo: Bool
    let bar: Int
}
