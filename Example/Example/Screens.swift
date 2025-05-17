//
//  Screens.swift
//  Example
//
//  Created by Kamaal M Farah on 23/04/2023.
//

import SwiftUI
import KamaalSettings
import KamaalNavigation

typealias AppNavigator = Navigator<Screens>

enum Screens: Hashable, Codable, CaseIterable, NavigatorStackValue, Sendable {
    case home
    case other
    case settings
    case coreData
    case coreDataChild(parentID: Item.ID)
    case settingsSelection(selection: SettingsScreenSelection)

    static var allCases: [Screens] {
        [.home, .other, .settings, .coreData]
    }

    var title: String {
        switch self {
        case .home: "Home"
        case .other: "Other"
        case .settings: "Settings"
        case .coreData: "Core Data"
        case .coreDataChild: "Child"
        case .settingsSelection: ""
        }
    }

    var imageSystemName: String {
        switch self {
        case .home:
            "house.fill"
        case .settings:
            "gear"
        default:
            ""
        }
    }

    var isTabItem: Bool {
        switch self {
        case .home, .settings:
            true
        default:
            false
        }
    }

    var isSidebarItem: Bool {
        switch self {
        case .home, .settings:
            true
        default:
            false
        }
    }

    func view(_ isSub: Bool) -> some View {
        MainView(screen: self, displayMode: isSub ? .inline : .large)
    }

    static let root: Screens = .home
}
