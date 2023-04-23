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

    @StateObject private var popUpManager = KPopUpManager()

    @State private var showPopUp = false
    @State private var showBrowser = false

    var body: some View {
        VStack {
            Button(action: { logger.info("Logging something") }) {
                Text("Loggin11111".digits)
            }
            Button(action: { showBrowser = true }) {
                Text("Show Browser")
            }
            Button(action: {
                popUpManager.showPopUp(
                    style: .bottom(title: "Title", type: .success, description: "Description"),
                    timeout: 3
                )
            }) {
                Text("Bottom popup")
            }
            Button(action: { showPopUp.toggle() }) {
                Text("Lite")
            }
            Button(action: {
                popUpManager.showPopUp(
                    style: .hud(title: "Empty thing", systemImageName: "airpodspro", description: "Below thing"),
                    timeout: nil
                )
            }) {
                Text("Hud popup")
            }
            StackNavigationLink(
                destination: Screens.coreData,
                nextView: { screen in MainView(screen: screen, displayMode: .inline) }
            ) {
                Text("Go to core data screen")
            }
            StackNavigationLink(
                destination: Screens.other,
                nextView: { screen in MainView(screen: screen, displayMode: .inline) }
            ) {
                Text("Go to other screen")
            }
        }
        .kBrowser(isPresented: $showBrowser, url: URL(staticString: "https://kamaal.io"), color: .red)
        .withKPopUp(popUpManager)
        .kPopUpLite(
            isPresented: $showPopUp,
            style: .bottom(title: "Title", type: .success, description: "Description"),
            backgroundColor: colorScheme == .dark ? .black : .white
        )
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
