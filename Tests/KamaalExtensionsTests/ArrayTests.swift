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

@Test(
    "Removes given element",
    arguments: [
        ([0, 1], [1], 0),
        ([], [], 2),
        ([1], [1], 1),
        ([1], [], 0),
    ],
)
func removesGivenElement(input: [Int], expectedResult: [Int], elementIndexToRemove: Int) {
    #expect(input.removed(at: elementIndexToRemove) == expectedResult)
}

// - MARK: ranged

@Test(
    "Ranges array",
    arguments: [
        ([0, 1, 2], 0, 3, [0, 1, 2]),
        ([0, 1, 2], 1, 3, [1, 2]),
        ([0, 1, 2], 0, 4, [0, 1, 2]),
        ([0, 1, 2], 4, 4, []),
        ([0, 1, 2], 10, 3, []),
    ],
)
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

@Test(
    "Keeps only unique elements",
    arguments: [
        ([0, 1, 2], [0, 1, 2]),
        ([0, 1, 1, 2], [0, 1, 2]),
    ],
)
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

@Test(
    "Concatenates 2 arrays together",
    arguments: [
        ([1, 2], [3, 4], [1, 2, 3, 4]),
        ([], [1, 2], [1, 2]),
        ([1, 2], [], [1, 2]),
    ],
)
func concatenatesTwoArraysTogether(firstArray: [Int], secondArray: [Int], result: [Int]) {
    #expect(firstArray.concat(secondArray) == result)
}

// - MARK: toSet

@Test(
    "Transforms array to set",
    arguments: [
        ([1, 2, 2], Set([1, 2])),
        ([1, 2, 3], Set([1, 2, 3])),
    ],
)
func transformsArrayToSet(input: [Int], expectedResult: Set<Int>) {
    #expect(input.toSet == expectedResult)
}

// - MARK: at

@Test(
    "Gets element with given index",
    arguments: [
        (0, 0),
        (1, 1),
        (2, 2),
        (-1, 2),
        (-2, 1),
        (-3, 0),
    ],
)
func getsElementWithGivenIndex(index: Int, element: Int) {
    let arr = (0 ..< 3).asArray()

    #expect(arr.at(index) == element)
}

@Test(
    "Fails to get given element because index is out of range",
    arguments: [
        -4,
        3,
    ],
)
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

    #expect(
        equatableArray.sorted(by: \.bar, using: .orderedDescending).map(\.bar) == [10, 8, 4, 0],
    )
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

// - MARK: sum

@Test("Sums Int array via key path to self")
func sumsIntArrayViaKeyPathToSelf() {
    let input = [1, 2, 3, 4]

    #expect(input.sum(by: \.self) == 10)
}

@Test("Sums Double array via key path to self")
func sumsDoubleArrayViaKeyPathToSelf() {
    let input: [Double] = [1.25, 2.75, 3.5]

    let result = input.sum(by: \.self)
    #expect(abs(result - 7.5) < 0.000001)
}

private struct PersonSumTest {
    let age: Int
    let salary: Double
}

@Test("Sums property via key path on custom type")
func sumsPropertyViaKeyPathOnCustomType() {
    let people = [
        PersonSumTest(age: 25, salary: 50000),
        PersonSumTest(age: 30, salary: 60000),
        PersonSumTest(age: 35, salary: 70000),
    ]

    #expect(people.sum(by: \.age) == 90)

    let totalSalary = people.sum(by: \.salary)
    #expect(abs(totalSalary - 180_000) < 0.000001)
}

@Test("Sums empty arrays to zero")
func sumsEmptyArraysToZero() {
    let emptyInts: [Int] = []
    let emptyDoubles: [Double] = []
    let emptyPeople: [PersonSumTest] = []

    #expect(emptyInts.sum(by: \.self) == 0)
    #expect(emptyDoubles.sum(by: \.self) == 0.0)
    #expect(emptyPeople.sum(by: \.age) == 0)
}

// - MARK: average

@Test("Averages Double array via key path to self")
func averagesDoubleArrayViaKeyPathToSelf() {
    let input: [Double] = [2.0, 4.0, 6.0]

    let avg = input.average(of: \.self)
    #expect(abs(avg - 4.0) < 0.000001)
}

@Test("Averages Float array via key path to self")
func averagesFloatArrayViaKeyPathToSelf() {
    let input: [Float] = [1.0, 2.0, 3.0, 4.0]

    let avg = input.average(of: \.self)
    #expect(abs(avg - 2.5) < 0.0001)
}

private struct Reading { let value: Double }

@Test("Averages property via key path on custom type")
func averagesPropertyViaKeyPathOnCustomType() {
    let readings = [Reading(value: 2.0), Reading(value: 4.0), Reading(value: 6.0)]

    let avg = readings.average(of: \.value)
    #expect(abs(avg - 4.0) < 0.000001)
}

@Test("Averages empty arrays to zero")
func averagesEmptyArraysToZero() {
    let emptyDoubles: [Double] = []
    let emptyFloats: [Float] = []

    #expect(emptyDoubles.average(of: \.self) == 0.0)
    #expect(emptyFloats.average(of: \.self) == 0.0)
}

// - MARK: average (integers)

@Test("Averages Int array via key path to self")
func averagesIntArrayViaKeyPathToSelf() {
    let input: [Int] = [1, 2, 3, 4]

    let avg = input.average(of: \.self)
    #expect(abs(avg - 2.5) < 0.000001)
}

@Test("Averages Int64 array via key path to self")
func averagesInt64ArrayViaKeyPathToSelf() {
    let input: [Int64] = [10, 20, 30]

    let avg = input.average(of: \.self)
    #expect(abs(avg - 20.0) < 0.000001)
}

@Test("Averages integer property via key path on custom type")
func averagesIntegerPropertyViaKeyPathOnCustomType() {
    let people = [
        PersonSumTest(age: 20, salary: 0),
        PersonSumTest(age: 21, salary: 0),
        PersonSumTest(age: 23, salary: 0),
    ]

    let avgAge = people.average(of: \.age)
    #expect(abs(avgAge - (64.0 / 3.0)) < 0.000001)
}

@Test("Averages empty integer arrays to zero")
func averagesEmptyIntegerArraysToZero() {
    let emptyInts: [Int] = []
    let emptyInt64s: [Int64] = []
    let emptyPeople: [PersonSumTest] = []

    #expect(emptyInts.average(of: \.self) == 0.0)
    #expect(emptyInt64s.average(of: \.self) == 0.0)
    #expect(emptyPeople.average(of: \.age) == 0.0)
}

private struct SomeEquatableObject: Equatable {
    let foo: Bool
    let bar: Int
}
