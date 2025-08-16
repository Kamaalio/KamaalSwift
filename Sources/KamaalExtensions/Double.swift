//
//  Double.swift
//
//
//  Created by Kamaal Farah on 28/10/2020.
//

import Foundation
import CoreGraphics

extension Double {
    /// Whether this double is a whole number.
    public var isDecimal: Bool {
        floor(self) == self
    }

    /// Converts to `Int` by truncating fractional part.
    public var int: Int {
        Int(self)
    }

    /// Converts to `Float`.
    public var float: Float {
        Float(self)
    }

    /// Converts to `CGFloat`.
    public var cgFloat: CGFloat {
        CGFloat(self)
    }

    /// Bridges to `NSNumber`.
    public var nsNumber: NSNumber {
        self as NSNumber
    }

    /// Calculates the percentage this value represents of `whole`.
    /// - Parameter whole: The total or maximum value.
    /// - Returns: `(self / whole) * 100`.
    public func percentageOf(_ whole: Double) -> Double {
        let calculation = (self / whole) * 100
        return calculation
    }

    /// Formats the double with a fixed number of fractional digits.
    /// - Parameter precision: Number of fractional digits.
    /// - Returns: A string representation.
    public func toFixed(_ precision: Int) -> String {
        String(format: "%.\(precision)f", self)
    }
}
