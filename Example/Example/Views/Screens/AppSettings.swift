//
//  AppSettings.swift
//  Example
//
//  Created by Kamaal M Farah on 13/05/2023.
//

import SwiftUI
import KamaalSettings

struct AppSettings: View {
    @State private var appColor = appColors[6]
    @State private var selectedLanguageOption = languageOptions[0]

    var body: some View {
        SettingsScreen(configuration: configuration)
            .onAppColorChange(handleOnAppColorChange)
            .onSettingsPreferenceChange(handlePreferenceChange)
    }

    private var configuration: SettingsConfiguration {
        .init(donations: donations, color: .init(colors: appColors, currentColor: appColor), preferences: preferences)
    }

    var preferences: [Preference] {
        [
            .init(
                id: UUID(uuidString: "66971130-a466-44cc-83f6-4759b51e7789")!,
                label: "Language",
                selectedOption: selectedLanguageOption,
                options: languageOptions
            ),
        ]
    }

    private func handleOnAppColorChange(_ appColor: AppColor) {
        self.appColor = appColor
    }

    private func handlePreferenceChange(_ preference: Preference) {
        selectedLanguageOption = preference.selectedOption
    }
}

private let languageOptions: [Preference.Option] = [
    .init(id: UUID(uuidString: "067fb9e5-af94-4425-965b-ebd70e7f9e56")!, label: "English"),
    .init(id: UUID(uuidString: "37c735d7-0804-469b-9219-ece30b0cbe4a")!, label: "Dutch"),
    .init(id: UUID(uuidString: "0a8db1a5-fe1c-44cf-ba66-15ce2da1fab3")!, label: "French"),
]

private let appColors: [AppColor] = [
    .init(id: UUID(uuidString: "1f6f9ac4-1ca6-4f77-880b-01580881a9b4")!, name: "Default", color: Color("AccentColor")),
    .init(id: UUID(uuidString: "57547f06-2d3e-4f3d-a639-59c13a5433bb")!, name: "Teal", color: .teal),
    .init(id: UUID(uuidString: "c5b39ff8-091a-4c46-a067-0bc5b1df4caf")!, name: "Purple", color: .purple),
    .init(id: UUID(uuidString: "1d2a4931-f1c2-42bf-b097-27908e1fa39a")!, name: "Green", color: .green),
    .init(id: UUID(uuidString: "7a664baf-b0ac-4764-86b4-3860773fe9c4")!, name: "Pink", color: .pink),
    .init(id: UUID(uuidString: "ab3aa7c5-c9e3-45a9-a2ef-f82603f11eab")!, name: "Orange", color: .orange),
    .init(id: UUID(uuidString: "0125142b-4a50-4f7f-b02c-a4963a6e4633")!, name: "Red", color: .red),
    .init(id: UUID(uuidString: "eb82e779-a7ba-4c75-a6e2-53d35332b940")!, name: "Blue", color: .blue),
]

let donations: [StoreKitDonation] = [
    .init(id: "io.kamaal.Example.Carrot", emoji: "🥕", weight: 1),
    .init(id: "io.kamaal.Example.House", emoji: "🏡", weight: 20),
    .init(id: "io.kamaal.Example.Ship", emoji: "🚢", weight: 69),
]

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings()
    }
}
