//
//  NavigationStackView.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import KamaalUI

public struct NavigationStackView<Sidebar: View, Screen: NavigatorStackValue, WrappedView: View>: View {
    @StateObject private var navigator: Navigator<Screen>

    let handleURLOpen: (_ url: URL) -> Screen?
    let sidebar: () -> Sidebar
    let passthroughEnvironment: (_ view: Screen.ScreenView) -> WrappedView

    public init(
        initialStack: [Screen],
        handleURLOpen: @escaping (_ url: URL) -> Screen? = { _ in nil },
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder passthroughEnvironment: @escaping (_ view: Screen.ScreenView) -> WrappedView,
    ) {
        self.sidebar = sidebar
        self._navigator = StateObject(wrappedValue: Navigator(stack: initialStack))
        self.passthroughEnvironment = passthroughEnvironment
        self.handleURLOpen = handleURLOpen
    }

    public var body: some View {
        self.navigationStackView
    }

    private var navigationStackView: some View {
        KJustStack {
            #if os(macOS)
            NavigationSplitView(
                sidebar: { self.sidebar() },
                detail: {
                    NavigationStack(path: self.navigator.getBindingPath()) {
                        self.passthroughEnvironment(self.navigator.currentStack.view(false))
                            .navigationDestination(for: Screen.self) { screen in
                                ZStack {
                                    Color(nsColor: .windowBackgroundColor)
                                    self.passthroughEnvironment(screen.view(true))
                                }
                                .transition(.move(edge: .trailing))
                                .navigationBarBackButtonHidden(true)
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
                },
            )
            .environmentObject(self.navigator)
            #else
            if UIDevice.current.userInterfaceIdiom == .pad {
                NavigationSplitView(
                    sidebar: { self.sidebar() },
                    detail: {
                        NavigationStack(path: self.navigator.getBindingPath()) {
                            self.passthroughEnvironment(self.navigator.currentStack.view(false))
                                .navigationDestination(for: Screen.self) { screen in
                                    self.passthroughEnvironment(screen.view(true))
                                }
                        }
                    },
                )
                .environmentObject(self.navigator)
            } else {
                TabView(selection: self.$navigator.currentStack) {
                    ForEach(self.navigator.screens.filter(\.isTabItem), id: \.self) { stack in
                        NavigationStack(path: self.navigator.getBindingPath(forStack: stack)) {
                            self.passthroughEnvironment(stack.view(false))
                                .navigationDestination(for: Screen.self) { screen in
                                    self.passthroughEnvironment(screen.view(true))
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
        .onOpenURL(perform: { url in
            guard let screen = handleURLOpen(url) else { return }
            self.navigator.navigate(to: screen)
        })
    }
}

#if DEBUG
struct NavigationStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackView(
            initialStack: [] as [PreviewScreenType],
            sidebar: { Text("Sidebar") },
            passthroughEnvironment: { screen in
                screen.padding()
            },
        )
    }
}
#endif
