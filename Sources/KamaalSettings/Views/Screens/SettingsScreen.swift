//
//  SettingsScreen.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

public struct SettingsScreen<ScreenType: NavigatorStackValue>: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    @EnvironmentObject private var store: Store

    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    public init(screenMapping: @escaping (_ settingsSelection: SettingsScreenSelection) -> ScreenType) {
        self.screenMapping = screenMapping
    }

    public var body: some View {
        SettingsScreenSelectionView<ScreenType>(screen: .root, screenMapping: self.screenMapping)
            .accentColor(self.settingsConfiguration.currentColor)
        #if os(macOS)
            .padding(.vertical, .medium)
            .ktakeSizeEagerly(alignment: .topLeading)
        #endif
            .onAppear(perform: self.handleOnAppear)
            .frame(minWidth: 250)
    }

    private func handleOnAppear() {
        Task { _ = try? await self.store.requestProducts().get() }
    }
}

// struct SettingsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsScreen(configuration: SettingsConfiguration(donations: []))
//    }
// }
