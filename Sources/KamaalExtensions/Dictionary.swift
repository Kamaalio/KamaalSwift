//
//  Dictionary.swift
//
//
//  Created by Kamaal M Farah on 11/01/2021.
//

import Foundation

extension Dictionary {
    public var urlQueryItems: [URLQueryItem] {
        compactMap { (key: Key, value: Value?) in
            guard let keyString = key as? String, let valueString = value as? String else { return nil }
            return URLQueryItem(name: keyString, value: valueString)
        }
    }

    public func merged(with dict: [Key: Value]) -> [Key: Value] {
        var mergedDict = self
        for (key, value) in dict {
            mergedDict[key] = value
        }
        return mergedDict
    }

    public func has(key: Key) -> Bool {
        index(forKey: key) != nil
    }

    public var asData: Data? {
        guard !isEmpty else { return nil }
        return try? JSONSerialization.data(withJSONObject: self)
    }
}
