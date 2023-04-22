//
//  RootSettingsScreen.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import SwiftUI
import KamaalUI

struct RootSettingsScreen: View {
    @Environment(\.settingsConfiguration) private var configuration: SettingsConfiguration

    @EnvironmentObject private var store: Store

    var body: some View {
        KScrollableForm {
            if configuration.donationsIsConfigured && store.hasDonations {
                SupportAuthorSection()
                    .padding(.horizontal, .medium)
            }
            if configuration.feedbackIsConfigured {
                FeedbackSection()
                    .padding(.horizontal, .medium)
            }
            if configuration.personalizationIsConfigured {
                PersonalizationSection()
                    .padding(.horizontal, .medium)
            }
            if configuration.preferencesIsConfigured {
                PreferencesSection()
                    .padding(.horizontal, .medium)
            }
            if configuration.featuresIsConfigured {
                FeaturesSection()
                    .padding(.horizontal, .medium)
            }
            if configuration.showLogs {
                MiscellaneousSection()
                    .padding(.horizontal, .medium)
            }
            if versionText != nil || configuration.acknowledgementsAreConfigured {
                AboutSection(versionText: versionText, buildNumber: buildNumber)
                    .padding(.horizontal, .medium)
            }
        }
    }

    private var versionText: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    private var buildNumber: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}

struct RootSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootSettingsScreen()
    }
}
