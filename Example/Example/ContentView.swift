//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalSettings
import KamaalNavigation

struct ContentView: View {
    @EnvironmentObject private var userSettings: UserSettings

    var body: some View {
        NavigationStackView(initialStack: [Screens](), sidebar: { Sidebar() }, passthroughEnvironment: { view in
            view
                .settingsEnvironment(configuration: self.userSettings.configuration)
        })
        .onAppColorChange(self.userSettings.handleOnAppColorChange)
        .onSettingsPreferenceChange(self.userSettings.handlePreferenceChange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
