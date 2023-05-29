//
//  String.swift
//
//
//  Created by Kamaal M Farah on 29/05/2023.
//

import Foundation

extension String {
    /// Fuzzy matches a string with a given search term (needle).
    /// - Parameter searchTerm: The search term to search for.
    /// - Returns: whether the an match found or not.
    public func fuzzyMatch(_ searchTerm: String) -> Bool {
        guard !searchTerm.isEmpty else { return true }

        var remainder = searchTerm.lowercased()
        for character in lowercased() where character == remainder[remainder.startIndex] {
            remainder.removeFirst()

            if remainder.isEmpty {
                return true
            }
        }

        return false
    }
}
