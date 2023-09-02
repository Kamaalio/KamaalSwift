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
        self.array.count
    }

    public var isEmpty: Bool {
        self.array.isEmpty
    }

    public mutating func enqueue(_ element: T) {
        if let max, count >= max {
            while self.count >= max {
                self.dequeue()
            }
        }

        self.array.append(element)
    }

    @discardableResult
    public mutating func dequeue() -> T? {
        guard !self.isEmpty else { return nil }

        return self.array.removeFirst()
    }
}
