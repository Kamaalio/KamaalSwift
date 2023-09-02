//
//  PersonalizationSection.swift
//
//
//  Created by Kamaal M Farah on 22/12/2022.
//

import SwiftUI
import KamaalUI

struct PersonalizationSection: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    var body: some View {
        KSection(header: "Personalization".localized(comment: "")) {
            if self.settingsConfiguration.colorsIsConfigured {
                NavigationLinkColorRow(
                    localizedLabel: "App colors",
                    comment: "",
                    color: .accentColor,
                    destination: .appColor
                )
                #if os(macOS)
                if self.settingsConfiguration.appIconIsConfigured {
                    Divider()
                }
                #endif
            }
            if self.settingsConfiguration.appIconIsConfigured {
                NavigationLinkImageRow(
                    localizedLabel: "App icon",
                    comment: "",
                    imageName: self.settingsConfiguration.appIcon!.currentIcon.imageName,
                    destination: .appIcon
                )
            }
        }
    }
}

struct PersonalizationSection_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizationSection()
    }
}
