//
//  MainView.swift
//  Example
//
//  Created by Kamaal M Farah on 27/04/2023.
//

import SwiftUI
import KamaalUI
import KamaalSettings
import KamaalNavigation

struct MainView: View {
    let screen: Screens
    let displayMode: DisplayMode

    init(screen: Screens, displayMode: DisplayMode) {
        self.screen = screen
        self.displayMode = displayMode
    }

    var body: some View {
        KJustStack {
            switch self.screen {
            case .home:
                HomeScreen()
            case .other:
                OtherScreen()
            case .settings:
                AppSettings()
            case .coreData:
                CoreDataScreen()
            case let .coreDataChild(parentID):
                CoreDataChildScreen(parentID: parentID)
            case let .settingsSelection(selection: selection):
                SettingsScreenSelectionView(screen: selection, screenMapping: { selection in
                    Screens.settingsSelection(selection: selection)
                })
            }
        }
        .navigationTitle(title: self.screen.title, displayMode: self.displayMode)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(screen: .home, displayMode: .large)
    }
}
