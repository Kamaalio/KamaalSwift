//
//  Double.swift
//
//
//  Created by Kamaal Farah on 28/10/2020.
//

import Foundation
import CoreGraphics

extension Double {
    public var isDecimal: Bool {
        floor(self) == self
    }

    public var int: Int {
        Int(self)
    }

    public var float: Float {
        Float(self)
    }

    public var cgFloat: CGFloat {
        CGFloat(self)
    }

    public var nsNumber: NSNumber {
        self as NSNumber
    }

    public func percentageOf(_ whole: Double) -> Double {
        let calculation = (self / whole) * 100
        return calculation
    }

    public func toFixed(_ precision: Int) -> String {
        String(format: "%.\(precision)f", self)
    }
}
