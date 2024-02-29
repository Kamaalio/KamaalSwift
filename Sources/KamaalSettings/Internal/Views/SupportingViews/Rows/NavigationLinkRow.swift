//
//  NavigationLinkRow.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

struct NavigationLinkRow<Value: View, ScreenType: NavigatorStackValue>: View {
    @EnvironmentObject private var store: Store

    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    let destination: ScreenType
    let value: () -> Value

    init(destination: ScreenType, @ViewBuilder value: @escaping () -> Value) {
        self.value = value
        self.destination = destination
    }

    var body: some View {
        StackNavigationLink(destination: self.destination) {
            self.valueView
        }
        .buttonStyle(.plain)
    }

    private var valueView: some View {
        self.value()
            .foregroundColor(.accentColor)
            .kInvisibleFill()
    }
}

// struct NavigationLinkRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationLinkRow(destination: .logs, value: { Text("Value") })
//    }
// }
