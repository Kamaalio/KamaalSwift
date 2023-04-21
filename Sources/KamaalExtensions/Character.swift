//
//  Character.swift
//
//
//  Created by Kamaal Farah on 28/10/2020.
//

import Foundation

extension Character {
    public var uppercased: Character {
        string.uppercased().first!
    }

    public var isUppercase: Bool {
        uppercased.string == string
    }

    public var lowercased: Character {
        string.lowercased().first!
    }

    public var isLowercase: Bool {
        lowercased.string == string
    }

    public var int: Int? {
        Int(string)
    }

    public var string: String {
        String(self)
    }
}
