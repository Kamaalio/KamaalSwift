//
//  FeatureRow.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI

struct FeatureRow: View {
    @State private var isEnabled: Bool

    let feature: Feature
    let onChange: (_ newFeature: Feature) -> Void

    init(feature: Feature, onChange: @escaping (_ newFeature: Feature) -> Void) {
        self.feature = feature
        self.onChange = onChange
        self._isEnabled = State(wrappedValue: feature.isEnabled)
    }

    var body: some View {
        HStack {
            AppText(string: self.feature.label)
                .bold()
                .foregroundColor(.accentColor)
            Spacer()
            Toggle(isOn: self.$isEnabled, label: { Text("") })
                .labelsHidden()
        }
        .onChange(of: self.isEnabled, perform: { newState in
            let newFeature = Feature(id: feature.id, label: self.feature.label, isEnabled: newState)
            self.onChange(newFeature)
        })
    }
}

struct FeatureRow_Previews: PreviewProvider {
    static var previews: some View {
        FeatureRow(
            feature: .init(
                id: UUID(uuidString: "d103d65d-585b-450e-8fcf-5fcece1d1250")!,
                label: "Fly away",
                isEnabled: false,
            ),
            onChange: { _ in },
        )
    }
}
