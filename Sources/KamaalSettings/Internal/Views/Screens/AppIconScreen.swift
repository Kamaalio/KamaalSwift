//
//  AppIconScreen.swift
//
//
//  Created by Kamaal M Farah on 24/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalLogger
import KamaalNavigation

private let logger = KamaalLogger(label: "AppIconScreen")

struct AppIconScreen<ScreenType: NavigatorStackValue>: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    @EnvironmentObject private var navigator: Navigator<ScreenType>

    var body: some View {
        SelectionScreenWrapper(
            navigationTitle: "App icon".localized(comment: ""),
            sectionTitle: "Icons".localized(comment: ""),
            items: self.settingsConfiguration.appIcon?.icons ?? [],
            onItemPress: self.changeAppIcon,
        ) { item in
            ImageTextRow(label: item.title, imageName: item.imageName)
        }
    }

    private func changeAppIcon(_ appIcon: AppIcon) {
        NotificationCenter.default.post(name: .appIconChanged, object: appIcon)
        logger.info("app icon changed to \(appIcon.title)")
        self.navigator.goBack()
    }
}
