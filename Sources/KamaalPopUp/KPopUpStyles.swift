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
            .bottom
        case .hud:
            .top
        }
    }
}

public enum KPopUpBottomType {
    case success
    case warning
    case error

    var iconName: String {
        switch self {
        case .success: "checkmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .error: "x.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: .green
        case .warning: .yellow
        case .error: .red
        }
    }
}
