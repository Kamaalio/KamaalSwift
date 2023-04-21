//
//  Optional.swift
//
//
//  Created by Kamaal M Farah on 16/01/2021.
//

import Foundation

extension Optional {
    public func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    public func unwrapped(or error: Error) throws -> Wrapped {
        guard let wrapped = self else { throw error }
        return wrapped
    }
}

extension Optional where Wrapped == Int {
    /// Adds increment to value if value is not nil.
    /// - Parameter increment: value to increment by.
    public mutating func add(_ increment: Int) {
        self = added(increment)
    }

    /// Adds increment to value if value is not nil and returns that value.
    /// - Parameter increment: value to increment by.
    public func added(_ increment: Int) -> Int? {
        guard let self = self else { return nil }
        return self + increment
    }
}
