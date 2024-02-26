//
//  Screens.swift
//  Example
//
//  Created by Kamaal M Farah on 23/04/2023.
//

import SwiftUI
import KamaalNavigation

enum Screens: Hashable, Codable, CaseIterable, NavigatorStackValue {
    case home
    case other
    case settings
    case coreData
    case coreDataChild(parentID: Item.ID)

    static var allCases: [Screens] {
        [.home, .other, .settings, .coreData]
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .other:
            return "Other"
        case .settings:
            return "Settings"
        case .coreData:
            return "Core Data"
        case .coreDataChild:
            return "Child"
        }
    }

    var imageSystemName: String {
        switch self {
        case .home:
            return "house.fill"
        case .settings:
            return "gear"
        default:
            return ""
        }
    }

    var isTabItem: Bool {
        switch self {
        case .home, .settings:
            return true
        default:
            return false
        }
    }

    var isSidebarItem: Bool {
        switch self {
        case .home, .settings:
            return true
        default:
            return false
        }
    }

    func view(_ isSub: Bool) -> some View {
        MainView(screen: self, displayMode: isSub ? .inline : .large)
    }

    static let root: Screens = .home
}
