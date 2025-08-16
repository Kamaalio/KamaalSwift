//
//  Array.swift
//
//
//  Created by Kamaal Farah on 13/11/2020.
//

import Foundation

extension Array where Element: Hashable {
    /// Transforms array to a `Set`
    public var toSet: Set<Element> {
        Set(self)
    }

    /// Makes array only contain unique elements.
    /// - Returns: An array with only unique elements.
    public func uniques() -> [Element] {
        var buffer: [Element] = []
        var added = Set<Element>()
        for element in self {
            if !added.contains(element) {
                buffer.append(element)
                added.insert(element)
            }
        }
        return buffer
    }
}

extension Array where Element: Identifiable {
    public var mappedByID: [Element.ID: Element] {
        reduce([:]) {
            var result = $0
            result[$1.id] = $1
            return result
        }
    }
}

extension Array {
    /// Transforms `Array` to an `NSSet`
    public var asNSSet: NSSet {
        NSSet(array: self)
    }

    /// Calculates the sum of values extracted from array elements using a key path.
    ///
    /// This method uses a key path to extract numeric values from each element in the array
    /// and returns their sum. The extracted values must conform to `AdditiveArithmetic`.
    ///
    /// - Parameter keyPath: A key path to a property of the array elements that conforms to `AdditiveArithmetic`.
    /// - Returns: The sum of all values extracted using the key path.
    ///
    /// - Complexity:
    ///   - Time: O(n), where n is the number of elements in the array
    ///   - Space: O(1), constant space complexity
    ///
    /// # Examples
    ///
    /// ```swift
    /// struct Person {
    ///     let age: Int
    ///     let salary: Double
    /// }
    ///
    /// let people = [
    ///     Person(age: 25, salary: 50000.0),
    ///     Person(age: 30, salary: 60000.0),
    ///     Person(age: 35, salary: 70000.0)
    /// ]
    ///
    /// let totalAge = people.sum(by: \.age)        // Returns 90
    /// let totalSalary = people.sum(by: \.salary)  // Returns 180000.0
    /// ```
    public func sum<T: AdditiveArithmetic>(by keyPath: KeyPath<Element, T>) -> T {
        reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    /// Calculates the average (arithmetic mean) of floating-point values extracted from array elements using a key
    /// path.
    ///
    /// - Parameter keyPath: A key path to a floating-point property of the array elements.
    /// - Returns: The average of all values, or `.zero` if the array is empty.
    ///
    /// - Note: This overload applies when the property type conforms to `BinaryFloatingPoint`.
    ///
    /// # Examples
    /// ```swift
    /// struct Reading { let value: Double }
    /// let readings = [Reading(value: 2.0), Reading(value: 4.0), Reading(value: 6.0)]
    /// let avg = readings.average(of: \.value) // 4.0
    /// ```
    public func average<T: BinaryFloatingPoint>(of keyPath: KeyPath<Element, T>) -> T {
        guard !isEmpty else { return .zero }
        return self.sum(by: keyPath) / T(count)
    }

    /// Calculates the average (arithmetic mean) of integer values extracted from array elements using a key path.
    ///
    /// - Parameter keyPath: A key path to an integer property of the array elements.
    /// - Returns: The average as a `Double`, or `0` if the array is empty.
    ///
    /// - Note: Returning a `Double` preserves fractional precision (e.g., average of 1 and 2 is 1.5).
    ///
    /// # Examples
    /// ```swift
    /// struct Person { let age: Int }
    /// let people = [Person(age: 20), Person(age: 21), Person(age: 23)]
    /// let averageAge = people.average(of: \.age) // 21.333333333333332
    /// ```
    public func average(of keyPath: KeyPath<Element, some BinaryInteger>) -> Double {
        guard !isEmpty else { return .zero }
        return Double(self.sum(by: keyPath)) / Double(count)
    }

    /// Returns ranged array slice.
    /// - Parameters:
    ///   - start: Where to start the range.
    ///   - end: Where to end the range.
    /// - Returns: Ranged array slice.
    public func ranged(from start: Int, to end: Int? = nil) -> ArraySlice<Element> {
        var end = end ?? count
        if end > count {
            end = count
        }
        var start = start
        if start > end {
            start = end
        }

        return self[start ..< end]
    }

    /// Removes element at the given index and returns a new array.
    /// - Parameter index: The index of the element to remove.
    /// - Returns: The given array with the item removed.
    public func removed(at index: Int) -> [Element] {
        var array = self
        if index < count {
            array.remove(at: index)
        }
        return array
    }

    /// Removes last element in array.
    /// Doesn't remove anything if array is empty.
    /// - Returns: An array with the last element removed
    public func removedLast() -> [Element] {
        var array = self
        _ = array.popLast()
        return array
    }

    /// Gets element at a specific given index. When a negative index has been given the indexing will be reversed.
    /// - Parameter index: A positive or negative index to access elements of this array.
    /// - Returns: Returns the element at the given index. If index is out of range, than this method will return nil.
    public func at(_ index: Int) -> Element? {
        guard index < count else { return nil }
        if index >= 0 {
            return self[index]
        }
        let reversedIndex = count + index
        guard reversedIndex >= 0 else { return nil }
        return self[reversedIndex]
    }

    /// Returns the first index of the sequence that satisfies the given key path and comparison value.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    ///
    /// - Parameters:
    ///   - keyPath: `KeyPath` of equatable type to search for.
    ///   - comparisonValue: The comparison value to to match the condition to search for.
    ///
    /// - Returns: The first index of the sequence that satisfies the given key path
    ///   and comparison value or nil if there is no element that satisfies the condition.
    public func findIndex<T: Equatable>(by keyPath: KeyPath<Element, T>, is comparisonValue: T)
        -> Int? {
        self.findIndex(where: { $0[keyPath: keyPath] == comparisonValue })
    }

    /// Returns the first index of the sequence that satisfies the given
    /// predicate.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///
    /// - Returns: The first index of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    public func findIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        try firstIndex(where: predicate)
    }

    public mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
}
