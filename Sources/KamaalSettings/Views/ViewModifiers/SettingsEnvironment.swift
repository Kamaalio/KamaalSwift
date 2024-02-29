//
//  SettingsEnvironment.swift
//
//
//  Created by Kamaal M Farah on 02/03/2024.
//

import SwiftUI

extension View {
    public func settingsEnvironment(configuration: SettingsConfiguration) -> some View {
        self
            .modifier(SettingsEnvironment(configuration: configuration))
    }
}

private struct SettingsEnvironment: ViewModifier {
    @StateObject private var store: Store

    let configuration: SettingsConfiguration

    init(configuration: SettingsConfiguration) {
        self._store = StateObject(wrappedValue: Store(donations: configuration.donations))
        self.configuration = configuration
    }

    func body(content: Content) -> some View {
        content
            .environmentObject(self.store)
            .environment(\.settingsConfiguration, self.configuration)
    }
}
