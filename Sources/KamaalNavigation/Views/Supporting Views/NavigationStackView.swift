//
//  NavigationStackView.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import KamaalUI

@available(macOS 11.0, *)
public struct NavigationStackView<Root: View, SubView: View, Screen: NavigatorStackValue>: View {
    @ObservedObject private var navigator: Navigator<Screen>

    let root: (Screen) -> Root
    let subView: (Screen) -> SubView
    let sidebar: () -> any View

    private let enableNavigationStack: Bool

    public init(
        stack: [Screen],
        @ViewBuilder root: @escaping (Screen) -> Root,
        @ViewBuilder subView: @escaping (Screen) -> SubView,
        @ViewBuilder sidebar: @escaping () -> any View
    ) {
        self.root = root
        self.subView = subView
        self.sidebar = sidebar
        self._navigator = ObservedObject(wrappedValue: Navigator(stack: stack))
        self.enableNavigationStack = true
    }

    public init(
        stackWithoutNavigationStack stack: [Screen],
        @ViewBuilder root: @escaping (Screen) -> Root,
        @ViewBuilder subView: @escaping (Screen) -> SubView
    ) {
        self.root = root
        self.subView = subView
        self.sidebar = { EmptyView() }
        self._navigator = ObservedObject(wrappedValue: Navigator(stack: stack))
        self.enableNavigationStack = false
    }

    public var body: some View {
        KJustStack {
            if enableNavigationStack {
                navigationStackView
            } else {
                viewWithoutNavigationStack
            }
        }
    }

    private var macView: some View {
        KJustStack {
            switch navigator.currentScreen {
            case .none:
                root(navigator.currentStack)
            case let .some(unwrapped):
                subView(unwrapped)
                    .id(unwrapped)
                    .transition(.move(edge: .trailing))
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button(action: { navigator.goBack() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
            }
        }
    }

    private var viewWithoutNavigationStack: some View {
        KJustStack {
            #if os(macOS)
            macView
            #else
            root(navigator.currentStack)
            #endif
        }
        .environmentObject(navigator)
    }

    private var navigationStackView: some View {
        KJustStack {
            #if os(macOS)
            NavigationView {
                AnyView(sidebar())
                macView
            }
            .environmentObject(navigator)
            #else
            if UIDevice.current.userInterfaceIdiom == .pad {
                NavigationView {
                    AnyView(sidebar())
                    root(navigator.currentStack)
                }
                .environmentObject(navigator)
            } else {
                TabView(selection: $navigator.currentStack) {
                    ForEach(navigator.screens.filter(\.isTabItem), id: \.self) { screen in
                        NavigationView {
                            root(screen)
                        }
                        .navigationViewStyle(.stack)
                        .tabItem {
                            Image(systemName: screen.imageSystemName)
                            Text(screen.title)
                        }
                        .tag(screen)
                    }
                }
                .environmentObject(navigator)
            }
            #endif
        }
    }

    public func onScreenChange(_ perform: @escaping (Screen) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: .hasChangedScreens)) { output in
            perform(output.object as? Screen ?? .root)
        }
    }
}

#if DEBUG
@available(macOS 11.0, *)
struct NavigationStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackView(
            stack: [] as [PreviewScreenType],
            root: { _ in Text("22") },
            subView: { _ in Text("s") },
            sidebar: { Text("Sidebar") }
        )
    }
}
#endif
