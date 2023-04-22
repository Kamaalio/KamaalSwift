//
//  SettingsConfiguration.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import SwiftUI
import KamaalExtensions

public struct SettingsConfiguration: Hashable {
    public let donations: [StoreKitDonation]
    public let feedback: FeedbackConfiguration?
    public let color: ColorsConfiguration?
    public let features: [Feature]
    public let acknowledgements: Acknowledgements?
    public let appIcon: AppIconConfiguration?
    public let preferences: [Preference]
    public let showLogs: Bool
    var isDefault = false

    public init(
        donations: [StoreKitDonation] = [],
        feedback: FeedbackConfiguration? = nil,
        color: ColorsConfiguration? = nil,
        features: [Feature] = [],
        acknowledgements: Acknowledgements? = nil,
        appIcon: AppIconConfiguration? = nil,
        preferences: [Preference] = [],
        showLogs: Bool = true
    ) {
        self.donations = donations
        self.feedback = feedback
        self.color = color
        self.features = features
        self.acknowledgements = acknowledgements
        self.appIcon = appIcon
        self.preferences = preferences.filter(\.optionsContainSelectedOption)
        self.showLogs = showLogs
    }

    private init(isDefault: Bool) {
        self.init()
        self.isDefault = isDefault
    }

    var donationsIsConfigured: Bool {
        !donations.isEmpty
    }

    var feedbackIsConfigured: Bool {
        feedback != nil
    }

    var colorsIsConfigured: Bool {
        guard let color else { return false }

        return color.colors.count > 1 && color.colors.find(where: { $0 == color.currentColor }) != nil
    }

    var appIconIsConfigured: Bool {
        guard let appIcon else { return false }

        return appIcon.icons.count > 1 && appIcon.icons.find(where: { $0 == appIcon.currentIcon }) != nil
    }

    var personalizationIsConfigured: Bool {
        colorsIsConfigured || appIconIsConfigured
    }

    var featuresIsConfigured: Bool {
        !features.isEmpty
    }

    var acknowledgementsAreConfigured: Bool {
        guard let acknowledgements else { return false }

        return !acknowledgements.contributors.isEmpty || !acknowledgements.packages.isEmpty
    }

    var preferencesIsConfigured: Bool {
        !preferences.isEmpty
    }

    var currentColor: Color {
        color?.currentColor.color ?? .accentColor
    }

    public struct FeedbackConfiguration: Hashable, Codable {
        public let token: String
        public let username: String
        public let repoName: String
        public let additionalLabels: [String]
        public let additionalData: Data?

        public init(
            token: String,
            username: String,
            repoName: String,
            additionalLabels: [String] = [],
            additionalData: Data? = nil
        ) {
            self.token = token
            self.username = username
            self.repoName = repoName
            self.additionalLabels = additionalLabels
            self.additionalData = additionalData
        }

        var additionalDataString: String? {
            guard let additionalData else { return nil }

            return String(data: additionalData, encoding: .utf8)
        }
    }

    public struct ColorsConfiguration: Hashable {
        public let colors: [AppColor]
        public let currentColor: AppColor

        public init(colors: [AppColor], currentColor: AppColor) {
            self.colors = colors
            self.currentColor = currentColor
        }
    }

    public struct AppIconConfiguration: Hashable, Codable {
        public let icons: [AppIcon]
        public let currentIcon: AppIcon

        public init(icons: [AppIcon], currentIcon: AppIcon) {
            self.icons = icons
            self.currentIcon = currentIcon
        }
    }

    static let `default` = SettingsConfiguration(isDefault: true)
}
