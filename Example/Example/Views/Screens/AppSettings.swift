//
//  AppSettings.swift
//  Example
//
//  Created by Kamaal M Farah on 13/05/2023.
//

import SwiftUI
import KamaalSettings

struct AppSettings: View {
    var body: some View {
        SettingsScreen<Screens>(screenMapping: { settingsSelection in
            Screens.settingsSelection(selection: settingsSelection)
        })
    }
}

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings()
    }
}
