//
//  NSSet.swift
//
//
//  Created by Kamaal M Farah on 10/01/2021.
//

import Foundation

extension NSSet {
    public func asArray<T>() -> [T]? {
        allObjects as? [T]
    }
}
