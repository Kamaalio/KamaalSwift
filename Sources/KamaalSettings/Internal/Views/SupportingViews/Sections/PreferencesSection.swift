//
//  PreferencesSection.swift
//
//
//  Created by Kamaal M Farah on 03/01/2023.
//

import SwiftUI
import KamaalUI
import KamaalLogger

private let logger = KamaalLogger(from: PreferencesSection.self)

struct PreferencesSection: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    var body: some View {
        KSection(header: "Preferences".localized(comment: "")) {
            ForEach(settingsConfiguration.preferences) { preference in
                NavigationLinkValueRow(
                    label: preference.label,
                    destination: .preferenceOptions(preference: preference)
                ) {
                    AppText(string: preference.selectedOption.label)
                        .bold()
                        .foregroundColor(.accentColor)
                }
            }
        }
    }

    private func onPreferenceChange(_ newPreference: Preference) {
        NotificationCenter.default.post(name: .preferenceChanged, object: newPreference)
        logger.info("preference changed to \(newPreference)")
    }
}

struct PreferencesSection_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesSection()
    }
}
