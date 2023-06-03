//
//  Queue.swift
//
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import Foundation

public struct Queue<T> {
    public private(set) var array: [T] = []
    public let max: Int?

    public init(max: Int? = nil) {
        self.max = max
    }

    public var count: Int {
        array.count
    }

    public var isEmpty: Bool {
        array.isEmpty
    }

    public mutating func enqueue(_ element: T) {
        if let max, count >= max {
            while count >= max {
                dequeue()
            }
        }

        array.append(element)
    }

    @discardableResult
    public mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }

        return array.removeFirst()
    }
}
