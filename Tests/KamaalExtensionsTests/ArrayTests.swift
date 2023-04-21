//
//  ArrayTests.swift
//
//
//  Created by Kamaal M Farah on 24/12/2021.
//

import Quick
import Nimble
import Foundation
import KamaalExtensions

final class ArrayTests: QuickSpec {
    override func spec() {
        // - MARK: removed

        describe("removed") {
            let cases = [
                ([0, 1], [1], 0),
                ([], [], 2),
                ([1], [1], 1),
                ([1], [], 0),
            ]
            for (input, expectedResult, elementIndexToRemove) in cases {
                it("Removes given element") {
                    expect(input.removed(at: elementIndexToRemove)) == expectedResult
                }
            }
        }

        // - MARK: ranged

        describe("ranged") {
            let cases: [([Int], Int, Int, [Int])] = [
                ([0, 1, 2], 0, 3, [0, 1, 2]),
                ([0, 1, 2], 1, 3, [1, 2]),
                ([0, 1, 2], 0, 4, [0, 1, 2]),
                ([0, 1, 2], 4, 4, []),
                ([0, 1, 2], 10, 3, []),
            ]
            for (array, start, end, expectedArray) in cases {
                it("ranges array") {
                    expect(array.ranged(from: start, to: end).asArray()) == expectedArray
                }
            }
        }

        // - MARK: map

        describe("map") {
            let cases: [([Int], Character, [Character])] = [
                ([0, 1, 2], "2", ["0", "1", "2"]),
                ([0, 1, 2], "1", ["0", "1"]),
                ([0, 1, 2], "9", ["0", "1", "2"]),
            ]
            for (array, limit, expectedArray) in cases {
                it("maps and limits untill predicate") {
                    let array = array
                        .map({ Character(String($0)) }, until: { $0 == limit })
                    expect(array) == expectedArray
                }
            }
        }

        // - MARK: uniques

        describe("uniques") {
            let cases = [
                ([0, 1, 2], [0, 1, 2]),
                ([0, 1, 1, 2], [0, 1, 2]),
            ]
            for (array, expectedArray) in cases {
                it("keeps only unique elements") {
                    expect(array.uniques()) == expectedArray
                }
            }
        }

        // - MARK: appended

        describe("appended") {
            it("appends element to array") {
                let array = [0, 1, 2]
                expect(array.appended(3)) == [0, 1, 2, 3]
            }
        }

        // - MARK: removedLast

        describe("removedLast") {
            it("removes last element in array") {
                let array = [0, 1, 2]
                expect(array.removedLast()) == [0, 1]
            }

            it("doesn't do anything because array is already empty") {
                let array: [Int] = []
                expect(array.removedLast()) == []
            }
        }

        // - MARK: asNSSet

        describe("asNSSet") {
            it("transforms array to an NSSet") {
                let array = [0, 1, 2]
                expect(array.asNSSet) == NSSet(array: [0, 1, 2])
            }
        }

        // - MARK: prepended

        describe("prepended") {
            it("prepends to an array") {
                let array = [0, 1, 2]
                expect(array.prepended(-1)) == [-1, 0, 1, 2]
            }
        }

        // - MARK: prepend

        describe("prepend") {
            it("prepends to an array") {
                var array = [0, 1, 2]
                array.prepend(-1)
                expect(array) == [-1, 0, 1, 2]
            }
        }

        // - MARK: concat

        describe("concat") {
            let cases = [
                ([1, 2], [3, 4], [1, 2, 3, 4]),
                ([], [1, 2], [1, 2]),
                ([1, 2], [], [1, 2]),
            ]

            for (firstArray, secondArray, result) in cases {
                it("concatenates 2 arrays together") {
                    expect(firstArray.concat(secondArray)) == result
                }
            }
        }

        // - MARK: toSet

        describe("toSet") {
            context("Transforms array to set") {
                let cases = [
                    ([1, 2, 2], [1, 2]),
                    ([1, 2, 3], [1, 2, 3]),
                ]
                func ascending(_ num1: Int, _ num2: Int) -> Bool { num1 < num2 }
                for (input, expectedResult) in cases {
                    it("transforms \(input) to \(expectedResult)") {
                        let set = input.toSet
                        expect(set.sorted(by: ascending(_:_:))) == expectedResult.sorted(by: ascending(_:_:))
                    }
                }
            }
        }

        // - MARK: at

        describe("at") {
            context("Gets elements with given index") {
                let arr = (0 ..< 3).asArray()
                let cases = [
                    (0, 0),
                    (1, 1),
                    (2, 2),
                    (-1, 2),
                    (-2, 1),
                    (-3, 0),
                ]
                for (index, element) in cases {
                    it("gets \(element) with the index of \(index) from \(arr)") {
                        expect(arr.at(index)).to(equal(element))
                    }
                }
            }
            context("Fails to get given element because index is out of range") {
                let arr = (0 ..< 3).asArray()
                let cases = [
                    -4,
                    3,
                ]
                for index in cases {
                    it("fails to get with the index of \(index)") {
                        expect(arr.at(index)).to(beNil())
                    }
                }
            }
        }

        // - MARK: findIndex

        describe("findIndex") {
            it("finds the index with a key path") {
                let equatableArray: [SomeEquatableObject] = [
                    .init(foo: false, bar: 0),
                    .init(foo: false, bar: 1),
                    .init(foo: true, bar: 2),
                    .init(foo: false, bar: 3),
                ]
                let result = equatableArray.findIndex(by: \.foo, is: true)
                expect(result).to(equal(2))
            }

            it("could not find index with a key path") {
                let equatableArray: [SomeEquatableObject] = [
                    .init(foo: false, bar: 0),
                    .init(foo: false, bar: 1),
                    .init(foo: false, bar: 2),
                    .init(foo: false, bar: 3),
                ]
                let result = equatableArray.findIndex(by: \.bar, is: 4)
                expect(result).to(beNil())
            }
        }

        // - MARK: sorted

        describe("sorted") {
            it("sorts by order ascending") {
                let equatableArray: [SomeEquatableObject] = [
                    .init(foo: false, bar: 10),
                    .init(foo: false, bar: 4),
                    .init(foo: false, bar: 0),
                    .init(foo: false, bar: 8),
                ]
                expect(equatableArray.sorted(by: \.bar, using: .orderedAscending).map(\.bar)) == [0, 4, 8, 10]
            }

            it("sorts by order descending") {
                let equatableArray: [SomeEquatableObject] = [
                    .init(foo: false, bar: 10),
                    .init(foo: false, bar: 4),
                    .init(foo: false, bar: 0),
                    .init(foo: false, bar: 8),
                ]
                expect(equatableArray.sorted(by: \.bar, using: .orderedDescending).map(\.bar)) == [10, 8, 4, 0]
            }

            it("sorts by order same") {
                let equatableArray: [SomeEquatableObject] = [
                    .init(foo: false, bar: 10),
                    .init(foo: false, bar: 4),
                    .init(foo: false, bar: 0),
                    .init(foo: false, bar: 8),
                ]
                expect(equatableArray.sorted(by: \.bar, using: .orderedSame).map(\.bar)) == [10, 4, 0, 8]
            }
        }
    }

    private struct SomeEquatableObject: Equatable {
        let foo: Bool
        let bar: Int
    }
}
