//
//  SettingsScreenSelectionView.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

public struct SettingsScreenSelectionView<ScreenType: NavigatorStackValue>: View {
    let screen: SettingsScreenSelection
    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    public init(
        screen: SettingsScreenSelection,
        screenMapping: @escaping (_ settingsSelection: SettingsScreenSelection) -> ScreenType,
    ) {
        self.screen = screen
        self.screenMapping = screenMapping
    }

    public var body: some View {
        KJustStack {
            switch self.screen {
            case .acknowledgements:
                AcknowledgementsScreen()
            case .appColor:
                AppColorScreen<ScreenType>()
            case .appIcon:
                AppIconScreen<ScreenType>()
            case let .feedback(style, description):
                FeedbackScreen<ScreenType>(style: style, description: description)
            case .logs:
                LogsScreen<ScreenType>(screenMapping: self.screenMapping)
            case .supportAuthor:
                SupportAuthorScreen<ScreenType>()
            case .root:
                RootSettingsScreen<ScreenType>(screenMapping: self.screenMapping)
            case let .preferenceOptions(preference):
                PreferenceOptionsScreen<ScreenType>(preference: preference)
            }
        }
        .navigationTitle(title: self.screen.title, displayMode: self.screen == .root ? .large : .inline)
    }
}

// struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(screen: .logs)
//    }
// }
