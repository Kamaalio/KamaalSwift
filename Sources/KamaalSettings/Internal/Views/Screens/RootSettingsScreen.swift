//
//  RootSettingsScreen.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

struct RootSettingsScreen<ScreenType: NavigatorStackValue>: View {
    @Environment(\.settingsConfiguration) private var configuration: SettingsConfiguration

    @EnvironmentObject private var store: Store

    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    var body: some View {
        KScrollableForm {
            if self.configuration.donationsIsConfigured && self.store.hasDonations {
                SupportAuthorSection<ScreenType>(screenMapping: self.screenMapping)
                    .padding(.horizontal, .medium)
            }
            if self.configuration.feedbackIsConfigured {
                FeedbackSection<ScreenType>(screenMapping: self.screenMapping)
                    .padding(.horizontal, .medium)
            }
            if self.configuration.personalizationIsConfigured {
                PersonalizationSection<ScreenType>(screenMapping: self.screenMapping)
                    .padding(.horizontal, .medium)
            }
            if self.configuration.preferencesIsConfigured {
                PreferencesSection<ScreenType>(screenMapping: self.screenMapping)
                    .padding(.horizontal, .medium)
            }
            if self.configuration.featuresIsConfigured {
                FeaturesSection()
                    .padding(.horizontal, .medium)
            }
            if self.configuration.showLogs {
                MiscellaneousSection<ScreenType>(screenMapping: self.screenMapping)
                    .padding(.horizontal, .medium)
            }
            if self.versionText != nil || self.configuration.acknowledgementsAreConfigured {
                AboutSection<ScreenType>(
                    versionText: self.versionText,
                    buildNumber: self.buildNumber,
                    screenMapping: self.screenMapping,
                )
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

// struct RootSettingsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RootSettingsScreen()
//    }
// }
