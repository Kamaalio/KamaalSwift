//
//  ScreenSelection.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import Foundation

enum ScreenSelection: Codable, Hashable {
    case acknowledgements
    case appColor
    case appIcon
    case feedback(style: FeedbackStyles, description: String)
    case logs
    case supportAuthor
}
