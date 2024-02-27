//
//  NavigationStackView.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import KamaalUI

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
            if self.enableNavigationStack {
                self.navigationStackView
            } else {
                self.viewWithoutNavigationStack
            }
        }
    }

    private var macView: some View {
        KJustStack {
            switch self.navigator.currentScreen {
            case .none:
                self.root(self.navigator.currentStack)
            case let .some(unwrapped):
                self.subView(unwrapped)
                    .id(unwrapped)
                    .transition(.move(edge: .trailing))
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button(action: { self.navigator.goBack() }) {
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
            self.macView
            #else
            self.root(self.navigator.currentStack)
            #endif
        }
        .environmentObject(self.navigator)
    }

    private var navigationStackView: some View {
        KJustStack {
            #if os(macOS)
            NavigationSplitView(
                sidebar: { AnyView(self.sidebar()) },
                detail: {
                    NavigationStack(path: self.navigator.getBindingPath()) {
                        self.macView
                            .navigationDestination(for: Screen.self) { screen in
                                screen.view(true)
                            }
                    }
                }
            )
            .environmentObject(self.navigator)
            #else
            if UIDevice.current.userInterfaceIdiom == .pad {
                NavigationSplitView(
                    sidebar: { AnyView(self.sidebar()) },
                    detail: {
                        NavigationStack(path: self.navigator.getBindingPath()) {
                            self.root(self.navigator.currentStack)
                                .navigationDestination(for: Screen.self) { screen in
                                    screen.view(true)
                                }
                        }
                    }
                )
                .environmentObject(self.navigator)
            } else {
                TabView(selection: self.$navigator.currentStack) {
                    ForEach(self.navigator.screens.filter(\.isTabItem), id: \.self) { stack in
                        NavigationStack(path: self.navigator.getBindingPath(forStack: stack)) {
                            self.root(stack)
                                .navigationDestination(for: Screen.self) { screen in
                                    screen.view(true)
                                }
                        }
                        .navigationViewStyle(.stack)
                        .tabItem {
                            Image(systemName: stack.imageSystemName)
                            Text(stack.title)
                        }
                        .tag(stack)
                    }
                }
                .environmentObject(self.navigator)
            }
            #endif
        }
    }
}

#if DEBUG
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
