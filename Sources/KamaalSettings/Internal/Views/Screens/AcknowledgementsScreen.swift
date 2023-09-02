//
//  AcknowledgementsScreen.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalBrowser

struct AcknowledgementsScreen: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    @State private var selectedPackageURL: URL?

    var body: some View {
        KScrollableForm {
            if let acknowledgements = settingsConfiguration.acknowledgements {
                if !acknowledgements.contributors.isEmpty {
                    ContributorsSection(contributors: acknowledgements.contributors)
                        .padding(.bottom, acknowledgements.packages.isEmpty ? .medium : .nada)
                }
                if !acknowledgements.packages.isEmpty {
                    PackagesSection(packages: acknowledgements.packages, onPackagePress: self.onPackagePress)
                        .padding(.top, acknowledgements.contributors.isEmpty ? .medium : .nada)
                }
            }
        }
        .accentColor(self.settingsConfiguration.currentColor)
        .kBrowser(self.$selectedPackageURL,
                  fallbackURL: URL(staticString: "https://kamaal.io"),
                  color: self.settingsConfiguration.currentColor)
    }

    private func onPackagePress(_ package: Acknowledgements.Package) {
        self.selectedPackageURL = package.url
    }
}

struct AcknowledgementsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementsScreen()
    }
}
