//
//  PreferenceOptionsScreen.swift
//
//
//  Created by Kamaal M Farah on 29/05/2023.
//

import SwiftUI
import KamaalUI
import KamaalLogger
import KamaalNavigation
import KamaalAlgorithms

private let logger = KamaalLogger(from: PreferenceOptionsScreen.self)

struct PreferenceOptionsScreen: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var navigator: Navigator<ScreenSelection>

    let preference: Preference

    init(preference: Preference) {
        self.preference = preference
    }

    var body: some View {
        SelectionScreenWrapper(
            navigationTitle: self.preference.label,
            sectionTitle: "Options".localized(comment: ""),
            items: self.preference.options,
            searchFilter: self.searchFilter,
            onItemPress: self.onPreferenceOptionChange
        ) { option in
            HStack {
                AppText(string: option.label)
                    .bold()
                Spacer()
                if self.isSelected(option) {
                    Image(systemName: "checkmark")
                        .kBold()
                }
            }
            .ktakeWidthEagerly(alignment: .leading)
        }
    }

    private func isSelected(_ option: Preference.Option) -> Bool {
        self.preference.selectedOption == option
    }

    private func searchFilter(_ option: Preference.Option, _ searchText: String) -> Bool {
        option.label.fuzzyMatch(searchText)
    }

    private func onPreferenceOptionChange(_ option: Preference.Option) {
        let newPreference = self.preference.setOption(option)
        NotificationCenter.default.post(name: .preferenceChanged, object: newPreference)
        logger.info("preference changed to \(newPreference)")
        #if os(macOS)
        self.navigator.goBack()
        #else
        self.presentationMode.wrappedValue.dismiss()
        #endif
    }
}

struct PreferenceOptionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceOptionsScreen(preference: Preference(
            id: UUID(uuidString: "c3172625-3e27-4448-aa98-ff013f718bfe")!,
            label: "Label",
            selectedOption: options[0],
            options: options
        ))
    }

    static let options: [Preference.Option] = [
        .init(id: UUID(uuidString: "4f139a2c-7d14-42ed-bfbe-b59228879875")!, label: "Option"),
    ]
}
