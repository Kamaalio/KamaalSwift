//
//  KPopUpStyles.swift
//
//
//  Created by Kamaal M Farah on 17/01/2022.
//

import SwiftUI

public enum KPopUpStyles {
    case bottom(title: String, type: KPopUpBottomType, description: String?)
    case hud(title: String, systemImageName: String, description: String?)

    var alignment: Alignment {
        switch self {
        case .bottom:
            return .bottom
        case .hud:
            return .top
        }
    }
}

public enum KPopUpBottomType {
    case success
    case warning
    case error

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "x.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .warning: return .yellow
        case .error: return .red
        }
    }
}
