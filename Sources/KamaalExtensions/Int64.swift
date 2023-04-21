//
//  Int64.swift
//
//
//  Created by Kamaal M Farah on 27/02/2021.
//

import Foundation

extension Int64 {
    public var int: Int {
        Int(self)
    }

    public var nsNumber: NSNumber {
        self as NSNumber
    }
}
