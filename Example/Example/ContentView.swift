//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalUI
import KamaalPopUp
import KamaalLogger
import KamaalBrowser
import KamaalSettings
import KamaalExtensions
import KamaalNavigation

private let logger = KamaalLogger(from: ContentView.self)

struct ContentView: View {
    var body: some View {
        NavigationStackView(
            stack: [] as [Screens],
            root: { screen in MainView(screen: screen) },
            subView: { screen in MainView(screen: screen, displayMode: .inline) },
            sidebar: { Sidebar() }
        )
        .onScreenChange { screen in
            print("screen", screen)
        }
    }
}

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

struct OtherScreen: View {
    var body: some View {
        StackNavigationBackButton(screenType: Screens.self) {
            Text("Back")
        }
    }
}

struct MainView: View {
    let screen: Screens
    let displayMode: DisplayMode

    init(screen: Screens, displayMode: DisplayMode = .large) {
        self.screen = screen
        self.displayMode = displayMode
    }

    var body: some View {
        KJustStack {
            switch screen {
            case .home:
                HomeScreen()
            case .other:
                OtherScreen()
            case .settings:
                SettingsScreen(configuration: .init())
            }
        }
        .navigationTitle(title: screen.title, displayMode: displayMode)
    }
}

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
        #if os(macOS)
        .toolbar(content: {
            Button(action: toggleSidebar) {
                Label("Toggle sidebar", systemImage: "sidebar.left")
                    .foregroundColor(.accentColor)
            }
        })
        #endif
    }

    #if os(macOS)
    private func toggleSidebar() {
        guard let firstResponder = NSApp.keyWindow?.firstResponder else { return }
        firstResponder.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}

enum Screens: Hashable, Codable, CaseIterable, NavigatorStackValue {
    case home
    case other
    case settings

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .other:
            return "Other"
        case .settings:
            return "Settings"
        }
    }

    var imageSystemName: String {
        switch self {
        case .home:
            return "house.fill"
        case .settings:
            return "gear"
        default:
            return ""
        }
    }

    var isTabItem: Bool {
        switch self {
        case .home, .settings:
            return true
        case .other:
            return false
        }
    }

    var isSidebarItem: Bool {
        switch self {
        case .home, .settings:
            return true
        case .other:
            return false
        }
    }

    static let root: Screens = .home
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
