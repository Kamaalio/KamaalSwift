//
//  Sidebar.swift
//  Example
//
//  Created by Kamaal M Farah on 27/04/2023.
//

import SwiftUI
import KamaalNavigation

struct Sidebar: View {
    var body: some View {
        List {
            Section("Scenes") {
                ForEach(Screens.allCases.filter(\.isSidebarItem), id: \.self) { screen in
                    StackNavigationChangeStackButton(destination: screen) {
                        Label(screen.title, systemImage: screen.imageSystemName)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
