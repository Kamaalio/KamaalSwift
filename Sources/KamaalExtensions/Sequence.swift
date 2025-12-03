//
//  Sequence.swift
//
//
//  Created by Kamaal Farah on 13/11/2020.
//

import Foundation

extension Sequence {
    /// Converts the sequence to an array.
    ///
    /// # Example
    /// ```swift
    /// let set: Set<Int> = [1, 2, 3]
    /// let array = set.asArray() // [1, 2, 3] in some order
    /// ```
    public func asArray() -> [Iterator.Element] {
        Array(self)
    }

    /// Splits the sequence into chunks of the specified size.
    ///
    /// - Parameters:
    ///   - chunkSize: The maximum number of elements per chunk.
    ///   - includeRemainder: Whether to include the remaining elements that don't fill a complete chunk. Defaults to
    /// `true`.
    /// - Returns: An array of arrays, where each inner array contains up to `chunkSize` elements.
    ///
    /// # Example
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// numbers.chunked(2) // [[1, 2], [3, 4], [5]]
    /// numbers.chunked(2, includeRemainder: false) // [[1, 2], [3, 4]]
    /// ```
    public func chunked(_ chunkSize: Int, includeRemainder: Bool = true) -> [[Element]] {
        var buffer: [Element] = []
        var chunks: [[Element]] = []
        for (index, element) in self.enumerated() {
            buffer.append(element)
            guard (index % chunkSize) == (chunkSize - 1) else { continue }

            chunks.append(buffer)
            buffer = []
        }

        if includeRemainder, buffer.count > 0 {
            return chunks.appended(buffer)
        }

        return chunks
    }

    /// Concatenates two arrays into a new array.
    /// - Parameter otherArray: The other array to add to the current one.
    /// - Returns: A concatenated array.
    public func concat(_ otherArray: [Element]) -> [Element] {
        self + otherArray
    }

    /// Sorts array by given key path using the given comparison result.
    /// - Parameters:
    ///   - keyPath: The keyPath of the object to sort by.
    ///   - comparison: The comparison method.
    /// - Returns: A sorted array.
    public func sorted(
        by keyPath: KeyPath<Element, some Comparable>,
        using comparison: ComparisonResult,
    ) -> [Element] {
        self.sorted(by: {
            switch comparison {
            case .orderedAscending:
                $0[keyPath: keyPath] < $1[keyPath: keyPath]
            case .orderedDescending:
                $0[keyPath: keyPath] > $1[keyPath: keyPath]
            case .orderedSame:
                $0[keyPath: keyPath] == $1[keyPath: keyPath]
            }
        })
    }

    /// Returns a new array with `newElement` appended to the end.
    /// - Parameter newElement: The element to append to the array.
    /// - Returns: The result of the array with an appended element.
    public func appended(_ newElement: Element) -> [Element] {
        self + [newElement]
    }

    /// Returns a new array with `element` inserted at the beginning.
    /// - Parameter element: The element to prepend to the array.
    /// - Returns: The result of the array with an prepended element.
    public func prepended(_ element: Element) -> [Element] {
        [element] + self
    }

    /// Maps each element and stops when `predicate` on the transformed value becomes `true`.
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
    public func find<T: Equatable>(by keyPath: KeyPath<Element, T>, is comparisonValue: T)
        -> Element? {
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

    /// Unpacks a sequence of optionals to only contain the non-`nil` values.
    /// - Returns: An array without optionals.
    ///
    /// # Example
    /// ```swift
    /// let vals: [Int?] = [1, nil, 3]
    /// let unpacked: [Int] = vals.unpacked() // [1, 3]
    /// ```
    public func unpacked<T>() -> [T] where Element == T? {
        compactMap(\.self)
    }

    /// Splits a sequence of `Result` values into arrays of successes and failures.
    /// - Returns: A tuple of successes and failures.
    ///
    /// # Example
    /// ```swift
    /// let results: [Result<Int, Error>] = [.success(1), .failure(MyError()), .success(2)]
    /// let grouped: (successes: [Int], failures: [Error]) = results.grouped()
    /// // grouped.successes == [1, 2]
    /// // grouped.failures.count == 1
    /// ```
    public func grouped<Success, Failure: Error>() -> (
        successes: [Success],
        failures: [Failure]
    ) where Element == Result<Success, Failure> {
        reduce((successes: [Success](), failures: [Failure]())) { results, result in
            switch result {
            case let .failure(failure):
                let failures = results.failures.appended(failure)
                return (results.successes, failures)
            case let .success(success):
                let successes = results.successes.appended(success)
                return (successes, results.failures)
            }
        }
    }
}
