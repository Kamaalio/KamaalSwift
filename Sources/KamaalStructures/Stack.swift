//
//  Stack.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import Foundation

public struct Stack<Value: Codable & Hashable>: Equatable, Codable {
    private var top: Node<Value>?
    public private(set) var count: Int

    public init() {
        self.top = .none
        self.count = 0
    }

    public var isEmpty: Bool {
        self.count == 0
    }

    public var array: [Value] {
        self.top?.array ?? []
    }

    public func peek() -> Value? {
        self.top?.value
    }

    public mutating func push(_ item: Value) {
        let currentTop = self.top
        self.top = Node(value: item, next: currentTop)
        self.count += 1
    }

    @discardableResult
    public mutating func pop() -> Value? {
        let currentTop = self.top
        self.top = self.top?.next

        guard let removedItem = currentTop?.value else { return nil }

        self.count -= 1
        return removedItem
    }

    public static func fromArray(_ array: [Value]) -> Stack<Value> {
        var stack = Stack<Value>()
        for item in array {
            stack.push(item)
        }
        return stack
    }
}
