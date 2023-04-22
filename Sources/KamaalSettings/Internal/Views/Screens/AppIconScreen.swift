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

private let logger = KamaalLogger(from: AppIconScreen.self)

struct AppIconScreen: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var navigator: Navigator<ScreenSelection>

    var body: some View {
        SelectionScreenWrapper(
            navigationTitle: "App icon".localized(comment: ""),
            sectionTitle: "Icons".localized(comment: ""),
            items: settingsConfiguration.appIcon?.icons ?? [],
            onItemPress: changeAppIcon
        ) { item in
            ImageTextRow(label: item.title, imageName: item.imageName)
        }
    }

    private func changeAppIcon(_ appIcon: AppIcon) {
        NotificationCenter.default.post(name: .appIconChanged, object: appIcon)
        logger.info("app icon changed to \(appIcon.title)")
        #if os(macOS)
        navigator.goBack()
        #else
        presentationMode.wrappedValue.dismiss()
        #endif
    }
}

struct AppIconScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppIconScreen()
    }
}
