//
//  Dictionary.swift
//
//
//  Created by Kamaal M Farah on 11/01/2021.
//

import Foundation

extension Dictionary {
    /// Converts a `[String: String?]` dictionary to URL query items.
    public var urlQueryItems: [URLQueryItem] {
        compactMap { (key: Key, value: Value?) in
            guard let keyString = key as? String, let valueString = value as? String else {
                return nil
            }
            return URLQueryItem(name: keyString, value: valueString)
        }
    }

    /// Returns a new dictionary by merging the given dictionary into this one, overriding duplicate keys.
    public func merged(with dict: [Key: Value]) -> [Key: Value] {
        var mergedDict = self
        for (key, value) in dict {
            mergedDict[key] = value
        }
        return mergedDict
    }

    /// Checks whether the dictionary contains the given key.
    public func has(key: Key) -> Bool {
        index(forKey: key) != nil
    }

    /// Serializes the dictionary to JSON `Data` if not empty.
    public var asData: Data? {
        guard !isEmpty else { return nil }
        return try? JSONSerialization.data(withJSONObject: self)
    }
}
