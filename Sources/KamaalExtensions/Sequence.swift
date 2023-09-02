//
//  Sequence.swift
//
//
//  Created by Kamaal Farah on 13/11/2020.
//

import Foundation

extension Sequence {
    /// Convert to an array.
    public func asArray() -> [Iterator.Element] {
        Array(self)
    }

    /// Concatenates 2 arrays together.
    /// - Parameter otherArray: The other array to add to the current one.
    /// - Returns: A concatenated array.
    public func concat(_ otherArray: [Element]) -> [Element] {
        self + otherArray
    }

    /// Sorts array by given keyPath using the given comparision result.
    /// - Parameters:
    ///   - keyPath: The keyPath of the object to sort by.
    ///   - comparison: The comparison method.
    /// - Returns: A sorted array.
    public func sorted(by keyPath: KeyPath<Element, some Comparable>,
                       using comparison: ComparisonResult) -> [Element] {
        self.sorted(by: {
            switch comparison {
            case .orderedAscending:
                return $0[keyPath: keyPath] < $1[keyPath: keyPath]
            case .orderedDescending:
                return $0[keyPath: keyPath] > $1[keyPath: keyPath]
            case .orderedSame:
                return $0[keyPath: keyPath] == $1[keyPath: keyPath]
            }
        })
    }

    /// Adds a new element at the end of the array and returns the result.
    /// - Parameter newElement: The element to append to the array.
    /// - Returns: The result of the array with an appended element.
    public func appended(_ newElement: Element) -> [Element] {
        self + [newElement]
    }

    /// Add a new element at the beginning of the array and returns the result.
    /// - Parameter element: The element to prepend to the array.
    /// - Returns: The result of the array with an prepended element.
    public func prepended(_ element: Element) -> [Element] {
        [element] + self
    }

    /// Maps and limits by given predicate.
    /// - Parameters:
    ///   - transform: Transform function.
    ///   - predicate: Limit predicate.
    /// - Returns: A mapped and limited sequence.
    public func map<T>(_ transform: (Element) -> T, until predicate: (T) -> Bool) -> [T] {
        var array: [T] = []
        for element in self {
            let transformedElement = transform(element)
            array.append(transformedElement)
            if predicate(transformedElement) {
                return array
            }
        }

        return array
    }

    /// Returns the first element of the sequence that satisfies the given key path and comparison value.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    ///
    /// - Parameters:
    ///   - keyPath: `KeyPath` of equatable type to search for.
    ///   - comparisonValue: The comparison value to to match the condition to search for.
    ///
    /// - Returns: The first element of the sequence that satisfies the given key path
    ///   and comparison value or nil if there is no element that satisfies the condition.
    public func find<T: Equatable>(by keyPath: KeyPath<Element, T>, is comparisonValue: T) -> Element? {
        self.find(where: { $0[keyPath: keyPath] == comparisonValue })
    }

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///
    /// - Returns: The first element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    public func find(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        try first(where: predicate)
    }
}
