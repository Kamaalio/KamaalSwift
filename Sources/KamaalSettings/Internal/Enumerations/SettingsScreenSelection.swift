//
//  SettingsScreenSelection.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import SwiftUI

public enum SettingsScreenSelection: Hashable, Codable, Sendable {
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
            "Settings".localized(comment: "")
        case .acknowledgements:
            "Acknowledgements".localized(comment: "")
        case .appColor:
            "App colors".localized(comment: "")
        case .appIcon:
            "App icon".localized(comment: "")
        case let .feedback(style, _):
            style.title
        case .logs:
            "Logs".localized(comment: "")
        case .supportAuthor:
            "Support Author".localized(comment: "")
        case let .preferenceOptions(preference):
            preference.label
        }
    }
}
