//
//  Bool.swift
//
//
//  Created by Kamaal M Farah on 10/01/2021.
//

import Foundation

extension Bool {
    public var int: Int {
        self ? 1 : 0
    }

    public var string: String {
        self ? "true" : "false"
    }
}
