//
//  SettingsScreen.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

public struct SettingsScreen: View {
    @StateObject private var store: Store

    private let initialStack: [ScreenSelection] = []

    let configuration: SettingsConfiguration

    public init(configuration: SettingsConfiguration) {
        self._store = StateObject(wrappedValue: Store(donations: configuration.donations))
        self.configuration = configuration
    }

    public var body: some View {
        NavigationStackWithoutNavigationStack(stack: self.initialStack, root: { screen in MainView(screen: screen) })
            .environmentObject(self.store)
            .accentColor(self.configuration.currentColor)
            .onAppear(perform: self.handleOnAppear)
            .environment(\.settingsConfiguration, self.configuration)
        #if os(macOS)
            .padding(.vertical, .medium)
            .ktakeSizeEagerly(alignment: .topLeading)
        #endif
            .frame(minWidth: 250)
    }

    private func handleOnAppear() {
        Task {
            _ = try? await self.store.requestProducts().get()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(configuration: SettingsConfiguration(donations: []))
    }
}
