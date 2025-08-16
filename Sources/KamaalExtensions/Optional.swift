//
//  Optional.swift
//
//
//  Created by Kamaal M Farah on 16/01/2021.
//

import Foundation

extension Optional {
    /// Returns the wrapped value or a default when `nil`.
    public func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    /// Returns the wrapped value or throws the given error if `nil`.
    public func unwrapped(or error: Error) throws -> Wrapped {
        guard let wrapped = self else { throw error }
        return wrapped
    }
}

extension Int? {
    /// Adds increment to value if value is not nil.
    /// - Parameter increment: value to increment by.
    public mutating func add(_ increment: Int) {
        self = self.added(increment)
    }

    /// Adds increment to value if value is not nil and returns that value.
    /// - Parameter increment: value to increment by.
    /// - Returns: The incremented value or `nil` if the original was `nil`.
    public func added(_ increment: Int) -> Int? {
        guard let self else { return nil }
        return self + increment
    }
}
