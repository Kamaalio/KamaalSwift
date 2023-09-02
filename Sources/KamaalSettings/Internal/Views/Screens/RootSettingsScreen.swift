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
            if self.configuration.donationsIsConfigured && self.store.hasDonations {
                SupportAuthorSection()
                    .padding(.horizontal, .medium)
            }
            if self.configuration.feedbackIsConfigured {
                FeedbackSection()
                    .padding(.horizontal, .medium)
            }
            if self.configuration.personalizationIsConfigured {
                PersonalizationSection()
                    .padding(.horizontal, .medium)
            }
            if self.configuration.preferencesIsConfigured {
                PreferencesSection()
                    .padding(.horizontal, .medium)
            }
            if self.configuration.featuresIsConfigured {
                FeaturesSection()
                    .padding(.horizontal, .medium)
            }
            if self.configuration.showLogs {
                MiscellaneousSection()
                    .padding(.horizontal, .medium)
            }
            if self.versionText != nil || self.configuration.acknowledgementsAreConfigured {
                AboutSection(versionText: self.versionText, buildNumber: self.buildNumber)
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
