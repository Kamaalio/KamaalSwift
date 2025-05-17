//
//  FeedbackStyles.swift
//
//
//  Created by Kamaal M Farah on 20/12/2022.
//

import Foundation

public enum FeedbackStyles: CaseIterable, Codable, Sendable {
    case feature
    case bug
    case other

    var title: String {
        switch self {
        case .feature:
            "Feature request".localized(comment: "")
        case .bug:
            "Report bug".localized(comment: "")
        case .other:
            "Other feedback".localized(comment: "")
        }
    }

    var imageSystemName: String {
        switch self {
        case .feature: "paperplane"
        case .bug: "ant"
        case .other: "newspaper"
        }
    }

    var labels: [String] {
        let labels: [String] = switch self {
        case .feature: ["enhancement"]
        case .bug: ["bug"]
        case .other: []
        }
        return labels + ["in app feedback"]
    }
}
