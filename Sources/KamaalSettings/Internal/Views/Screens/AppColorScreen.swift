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

private let logger = KamaalLogger(label: "AppColorScreen")

struct AppColorScreen<ScreenType: NavigatorStackValue>: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    @EnvironmentObject private var navigator: Navigator<ScreenType>

    var body: some View {
        SelectionScreenWrapper(
            navigationTitle: "App colors".localized(comment: ""),
            sectionTitle: "Colors".localized(comment: ""),
            items: self.settingsConfiguration.color?.colors ?? [],
            onItemPress: self.changeAppColor
        ) { appColor in
            ColorTextRow(label: appColor.name, color: appColor.color)
        }
    }

    private func changeAppColor(_ appColor: AppColor) {
        NotificationCenter.default.post(name: .appColorChanged, object: appColor)
        logger.info("app color changed to \(appColor)")
        self.navigator.goBack()
    }
}

// struct AppColorScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AppColorScreen()
//    }
// }
