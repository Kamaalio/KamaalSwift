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
    @StateObject private var store: Store

    let configuration: SettingsConfiguration
    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    public init(
        configuration: SettingsConfiguration,
        screenMapping: @escaping (_ settingsSelection: SettingsScreenSelection) -> ScreenType
    ) {
        self._store = StateObject(wrappedValue: Store(donations: configuration.donations))
        self.configuration = configuration
        self.screenMapping = screenMapping
    }

    public var body: some View {
        SettingsScreenSelectionView<ScreenType>(screen: .root, screenMapping: self.screenMapping)
            .accentColor(self.configuration.currentColor)
        #if os(macOS)
            .padding(.vertical, .medium)
            .ktakeSizeEagerly(alignment: .topLeading)
        #endif
            .onAppear(perform: self.handleOnAppear)
            .frame(minWidth: 250)
            .environmentObject(self.store)
            .environment(\.settingsConfiguration, self.configuration)
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
