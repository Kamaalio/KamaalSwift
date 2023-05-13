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

    var body: some View {
        SettingsScreen(configuration: configuration)
            .onAppColorChange(handleOnAppColorChange)
    }

    private var configuration: SettingsConfiguration {
        .init(color: .init(colors: appColors, currentColor: appColor))
    }

    private func handleOnAppColorChange(_ appColor: AppColor) {
        self.appColor = appColor
    }
}

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

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings()
    }
}
