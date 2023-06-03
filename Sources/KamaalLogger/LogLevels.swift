//
//  LogLevels.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import SwiftUI

public enum LogLevels: String, CaseIterable {
    case error
    case warning
    case info
    case debug

    /// Representation color.
    public var color: Color {
        switch self {
        case .info:
            return .green
        case .warning:
            return .yellow
        case .error:
            return .red
        case .debug:
            return .gray
        }
    }
}
