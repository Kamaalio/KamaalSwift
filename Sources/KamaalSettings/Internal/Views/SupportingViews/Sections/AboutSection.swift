//
//  AboutSection.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI

struct AboutSection: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    let versionText: String?
    let buildNumber: String?

    var body: some View {
        KSection(header: "About".localized(comment: "")) {
            if self.settingsConfiguration.acknowledgementsAreConfigured {
                NavigationLinkImageRow(
                    localizedLabel: "Acknowledgements",
                    comment: "",
                    imageSystemName: self.acknowledgementsImageSystemName,
                    destination: .acknowledgements
                )
                #if os(macOS)
                if versionText != nil {
                    Divider()
                }
                #endif
            }
            if let versionText {
                ValueRow(localizedLabel: "Version", comment: "") {
                    AppText(string: versionText)
                    if let buildNumber {
                        AppText(string: buildNumber)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
        }
    }

    private var acknowledgementsImageSystemName: String {
        if #available(macOS 13.0, iOS 16.0, *) {
            return "medal.fill"
        }
        return "burst.fill"
    }
}

struct AboutSection_Previews: PreviewProvider {
    static var previews: some View {
        AboutSection(versionText: "1.0.0", buildNumber: "420")
    }
}
