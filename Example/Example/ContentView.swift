//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalUI
import KamaalLogger
import KamaalBrowser
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
    @State private var showBrowser = false

    var body: some View {
        VStack {
            Button(action: { logger.info("Logging something") }) {
                Text("Loggin11111".digits)
            }
            Button(action: { showBrowser = true }) {
                Text("Show Browser")
            }
            StackNavigationLink(
                destination: Screens.other,
                nextView: { screen in MainView(screen: screen, displayMode: .inline) }
            ) {
                Text("Go to other screen")
            }
        }
        .kBrowser(isPresented: $showBrowser, url: URL(staticString: "https://kamaal.io"), color: .red)
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

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .other:
            return "Other"
        }
    }

    var imageSystemName: String {
        switch self {
        case .home:
            return "house.fill"
        default:
            return ""
        }
    }

    var isTabItem: Bool {
        switch self {
        case .home:
            return true
        case .other:
            return false
        }
    }

    var isSidebarItem: Bool {
        switch self {
        case .home:
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
