//
//  NavigationLinkRow.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI

struct NavigationLinkRow<Value: View>: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var store: Store

    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    let destination: ScreenSelection
    let value: () -> Value

    init(destination: ScreenSelection, @ViewBuilder value: @escaping () -> Value) {
        self.value = value
        self.destination = destination
    }

    var body: some View {
        #if os(macOS)
        AppButton(action: { navigator.navigate(to: destination) }) {
            valueView
        }
        #else
        NavigationLink(destination: {
            MainView(screen: destination)
                .environment(\.settingsConfiguration, settingsConfiguration)
                .environmentObject(store)
        }) {
            valueView
        }
        #endif
    }

    private var valueView: some View {
        value()
            .foregroundColor(.accentColor)
            .invisibleFill()
    }
}

struct NavigationLinkRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLinkRow(destination: .logs, value: { Text("Value") })
    }
}
