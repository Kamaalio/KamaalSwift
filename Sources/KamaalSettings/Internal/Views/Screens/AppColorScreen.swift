//
//  AppColorScreen.swift
//
//
//  Created by Kamaal M Farah on 22/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalLogger
import KamaalNavigation

private let logger = KamaalLogger(from: AppColorScreen.self)

struct AppColorScreen: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var navigator: Navigator<ScreenSelection>

    var body: some View {
        SelectionScreenWrapper(
            navigationTitle: "App colors".localized(comment: ""),
            sectionTitle: "Colors".localized(comment: ""),
            items: settingsConfiguration.color?.colors ?? [],
            onItemPress: changeAppColor
        ) { appColor in
            ColorTextRow(label: appColor.name, color: appColor.color)
        }
    }

    private func changeAppColor(_ appColor: AppColor) {
        NotificationCenter.default.post(name: .appColorChanged, object: appColor)
        logger.info("app color changed to \(appColor)")
        #if os(macOS)
        navigator.goBack()
        #else
        presentationMode.wrappedValue.dismiss()
        #endif
    }
}

struct AppColorScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppColorScreen()
    }
}
