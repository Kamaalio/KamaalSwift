//
//  PackagesSection.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI

struct PackagesSection: View {
    let packages: [Acknowledgements.Package]
    let onPackagePress: (_ package: Acknowledgements.Package) -> Void

    var body: some View {
        KSection(header: "Packages".localized(comment: "")) {
            ForEach(packages, id: \.self) { package in
                AppButton(action: { onPackagePress(package) }) {
                    VStack(alignment: .leading) {
                        AppText(string: package.name)
                            .bold()
                            .foregroundColor(.accentColor)
                        AppText(string: package.url.absoluteString)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .ktakeWidthEagerly(alignment: .leading)
                }
                #if os(macOS)
                if package != packages.last {
                    Divider()
                }
                #endif
            }
        }
        .padding(.horizontal, .medium)
        .padding(.bottom, .medium)
    }
}

struct PackagesSection_Previews: PreviewProvider {
    static var previews: some View {
        PackagesSection(packages: [], onPackagePress: { _ in })
    }
}
