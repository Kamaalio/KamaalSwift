//
//  PreferenceRow.swift
//
//
//  Created by Kamaal M Farah on 03/01/2023.
//

import SwiftUI
import KamaalUI

struct PreferenceRow: View {
    @State private var selectedOption: Preference.Option

    let preference: Preference
    let onChange: (_ newPreference: Preference) -> Void

    init(preference: Preference, onChange: @escaping (_ newPreference: Preference) -> Void) {
        self.preference = preference
        self.onChange = onChange
        self._selectedOption = State(initialValue: preference.selectedOption)
    }

    var body: some View {
        HStack {
            AppText(string: preference.label)
                .bold()
                .foregroundColor(.accentColor)
                .ktakeWidthEagerly(alignment: .leading)
            Spacer()
            Picker("", selection: $selectedOption) {
                ForEach(preference.options) { option in
                    Text(option.label)
                        .tag(option)
                }
            }
        }
        .onChange(of: selectedOption, perform: { newValue in
            let newPreference = Preference(
                id: preference.id,
                label: preference.label,
                selectedOption: newValue,
                options: preference.options
            )
            onChange(newPreference)
        })
        .onChange(of: preference, perform: { newValue in
            if selectedOption != newValue.selectedOption {
                selectedOption = newValue.selectedOption
            }
        })
    }
}

struct PreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRow(
            preference: Preference(
                id: UUID(uuidString: "c3172625-3e27-4448-aa98-ff013f718bfe")!,
                label: "Label",
                selectedOption: options[0],
                options: options
            ),
            onChange: { _ in }
        )
    }

    static let options: [Preference.Option] = [
        .init(id: UUID(uuidString: "4f139a2c-7d14-42ed-bfbe-b59228879875")!, label: "Option"),
    ]
}
