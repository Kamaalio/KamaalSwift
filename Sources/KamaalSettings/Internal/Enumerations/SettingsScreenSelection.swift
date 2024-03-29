//
//  SettingsScreenSelection.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import SwiftUI

public enum SettingsScreenSelection: Hashable, Codable {
    case root
    case acknowledgements
    case appColor
    case appIcon
    case feedback(style: FeedbackStyles, description: String)
    case logs
    case supportAuthor
    case preferenceOptions(preference: Preference)

    var title: String {
        switch self {
        case .root:
            return "Settings".localized(comment: "")
        case .acknowledgements:
            return "Acknowledgements".localized(comment: "")
        case .appColor:
            return "App colors".localized(comment: "")
        case .appIcon:
            return "App icon".localized(comment: "")
        case let .feedback(style, _):
            return style.title
        case .logs:
            return "Logs".localized(comment: "")
        case .supportAuthor:
            return "Support Author".localized(comment: "")
        case let .preferenceOptions(preference):
            return preference.label
        }
    }
}
