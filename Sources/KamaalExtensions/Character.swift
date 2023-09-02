//
//  Character.swift
//
//
//  Created by Kamaal Farah on 28/10/2020.
//

import Foundation

extension Character {
    public var uppercased: Character {
        self.string.uppercased().first!
    }

    public var isUppercase: Bool {
        self.uppercased.string == self.string
    }

    public var lowercased: Character {
        self.string.lowercased().first!
    }

    public var isLowercase: Bool {
        self.lowercased.string == self.string
    }

    public var int: Int? {
        Int(self.string)
    }

    public var string: String {
        String(self)
    }
}
