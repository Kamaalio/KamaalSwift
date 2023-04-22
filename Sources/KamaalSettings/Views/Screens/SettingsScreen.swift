//
//  SettingsScreen.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import SwiftUI
import KamaalUI

public struct SettingsScreen: View {
    @StateObject private var store: Store

    let configuration: SettingsConfiguration

    public init(configuration: SettingsConfiguration) {
        self._store = StateObject(wrappedValue: Store(donations: configuration.donations))
        self.configuration = configuration
    }

    public var body: some View {
        NavigationStackView {
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
            .navigationTitle(localizedTitle: "Settings", comment: "", displayMode: .large)
        }
        .environmentObject(store)
        .accentColor(configuration.currentColor)
        .onAppear(perform: handleOnAppear)
        .environment(\.settingsConfiguration, configuration)
        #if os(macOS)
            .padding(.vertical, .medium)
            .ktakeSizeEagerly(alignment: .topLeading)
        #endif
            .frame(minWidth: 250)
    }

    private var versionText: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    private var buildNumber: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    private func handleOnAppear() {
        Task {
            _ = try? await store.requestProducts().get()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(configuration: SettingsConfiguration(donations: []))
    }
}
