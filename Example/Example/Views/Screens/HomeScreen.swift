//
//  HomeScreen.swift
//  Example
//
//  Created by Kamaal M Farah on 27/04/2023.
//

import SwiftUI
import KamaalPopUp
import KamaalLogger
import KamaalBrowser
import KamaalExtensions
import KamaalNavigation

private let logger = KamaalLogger(from: HomeScreen.self)

struct HomeScreen: View {
    @Environment(\.colorScheme) private var colorScheme

    @EnvironmentObject private var navigator: AppNavigator

    @StateObject private var popUpManager = KPopUpManager()

    @State private var showPopUp = false
    @State private var showBrowser = false

    var body: some View {
        VStack {
            Button(action: { logger.info("Logging something") }) {
                Text("Loggin11111".digits)
            }
            Button(action: { self.showBrowser = true }) {
                Text("Show Browser")
            }
            Button(action: {
                self.popUpManager.showPopUp(
                    style: .bottom(title: "Title", type: .success, description: "Description"),
                    timeout: 3,
                )
            }) {
                Text("Bottom popup")
            }
            Button(action: { self.showPopUp.toggle() }) {
                Text("Lite")
            }
            Button(action: {
                self.popUpManager.showPopUp(
                    style: .hud(title: "Empty thing", systemImageName: "airpodspro", description: "Below thing"),
                    timeout: nil,
                )
            }) {
                Text("Hud popup")
            }
            Button(action: { self.navigator.navigate(to: .coreData) }) {
                Text("Brogrammatic core data screen nav")
            }
            StackNavigationLink(destination: Screens.coreData) {
                Text("Go to core data screen")
            }
            StackNavigationLink(destination: Screens.other) {
                Text("Go to other screen")
            }
        }
        .kBrowser(isPresented: self.$showBrowser, url: URL(staticString: "https://kamaal.io"), color: .red)
        .withKPopUp(self.popUpManager)
        .kPopUpLite(
            isPresented: self.$showPopUp,
            style: .bottom(title: "Title", type: .success, description: "Description"),
            backgroundColor: self.colorScheme == .dark ? .black : .white,
        )
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
