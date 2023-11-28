//
//  MainView.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

struct MainView: View {
    let screen: ScreenSelection

    var body: some View {
        KJustStack {
            switch self.screen {
            case .acknowledgements:
                AcknowledgementsScreen()
            case .appColor:
                AppColorScreen()
            case .appIcon:
                AppIconScreen()
            case let .feedback(style, description):
                FeedbackScreen(style: style, description: description)
            case .logs:
                LogsScreen()
            case .supportAuthor:
                SupportAuthorScreen()
            case .root:
                RootSettingsScreen()
            case let .preferenceOptions(preference):
                PreferenceOptionsScreen(preference: preference)
            }
        }
        .navigationTitle(title: self.screen.title, displayMode: self.screen == .root ? .large : .inline)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(screen: .logs)
    }
}
