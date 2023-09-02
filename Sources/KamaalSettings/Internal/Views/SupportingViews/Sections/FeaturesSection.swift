//
//  FeaturesSection.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalLogger

private let logger = KamaalLogger(from: FeaturesSection.self)

struct FeaturesSection: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    var body: some View {
        KSection(header: "Features".localized(comment: "")) {
            ForEach(self.settingsConfiguration.features) { feature in
                FeatureRow(feature: feature, onChange: self.onFeatureChange)
            }
        }
    }

    private func onFeatureChange(_ newFeature: Feature) {
        NotificationCenter.default.post(name: .featureChanged, object: newFeature)
        logger.info("feature changed to \(newFeature)")
    }
}

struct FeaturesSection_Previews: PreviewProvider {
    static var previews: some View {
        FeaturesSection()
    }
}
