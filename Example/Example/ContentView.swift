//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalNavigation

struct ContentView: View {
    var body: some View {
        NavigationStackView(
            stack: [] as [Screens],
            root: { screen in MainView(screen: screen, displayMode: .large) },
            subView: { screen in MainView(screen: screen, displayMode: .inline) },
            sidebar: { Sidebar() }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
