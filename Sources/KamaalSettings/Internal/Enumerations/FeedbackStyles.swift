//
//  FeedbackStyles.swift
//
//
//  Created by Kamaal M Farah on 20/12/2022.
//

import Foundation

enum FeedbackStyles: CaseIterable, Codable {
    case feature
    case bug
    case other

    var title: String {
        switch self {
        case .feature:
            return "Feature request".localized(comment: "")
        case .bug:
            return "Report bug".localized(comment: "")
        case .other:
            return "Other feedback".localized(comment: "")
        }
    }

    var imageSystemName: String {
        switch self {
        case .feature: return "paperplane"
        case .bug: return "ant"
        case .other: return "newspaper"
        }
    }

    var labels: [String] {
        let labels: [String]
        switch self {
        case .feature: labels = ["enhancement"]
        case .bug: labels = ["bug"]
        case .other: labels = []
        }
        return labels + ["in app feedback"]
    }
}
