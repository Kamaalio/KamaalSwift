//
//  NSSet.swift
//
//
//  Created by Kamaal M Farah on 10/01/2021.
//

import Foundation

extension NSSet {
    /// Attempts to cast the set's `allObjects` to an array of `T`.
    /// - Returns: The casted array or `nil` when casting fails.
    public func asArray<T>() -> [T]? {
        allObjects as? [T]
    }
}
