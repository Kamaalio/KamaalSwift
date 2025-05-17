//
//  LogLevels.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import SwiftUI

public enum LogLevels: String, CaseIterable, Sendable {
    case error
    case warning
    case info
    case debug

    /// Representation color.
    public var color: Color {
        switch self {
        case .info:
            .green
        case .warning:
            .yellow
        case .error:
            .red
        case .debug:
            .gray
        }
    }
}
