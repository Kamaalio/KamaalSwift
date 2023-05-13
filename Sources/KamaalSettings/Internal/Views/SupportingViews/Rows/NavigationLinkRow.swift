//
//  NavigationLinkRow.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalNavigation

struct NavigationLinkRow<Value: View>: View {
    @EnvironmentObject private var store: Store

    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    let destination: ScreenSelection
    let value: () -> Value

    init(destination: ScreenSelection, @ViewBuilder value: @escaping () -> Value) {
        self.value = value
        self.destination = destination
    }

    var body: some View {
        StackNavigationLink(
            destination: destination,
            nextView: { screen in MainView(screen: screen).environment(\.settingsConfiguration, settingsConfiguration) }
        ) {
            valueView
        }
        .buttonStyle(.plain)
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
