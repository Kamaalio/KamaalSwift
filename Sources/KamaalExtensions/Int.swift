//
//  Int.swift
//
//
//  Created by Kamaal M Farah on 27/02/2021.
//

import Foundation

extension Int {
    public var int64: Int64 {
        Int64(self)
    }

    public var nsNumber: NSNumber {
        self as NSNumber
    }
}
