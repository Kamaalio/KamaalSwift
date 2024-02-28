//
//  NavigationStackView.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import KamaalUI

public struct NavigationStackView<Screen: NavigatorStackValue>: View {
    @ObservedObject private var navigator: Navigator<Screen>

    let sidebar: () -> any View

    public init(stack: [Screen], @ViewBuilder sidebar: @escaping () -> any View) {
        self.sidebar = sidebar
        self._navigator = ObservedObject(wrappedValue: Navigator(stack: stack))
    }

    public var body: some View {
        self.navigationStackView
    }

    private var macView: some View {
        KJustStack {
            switch self.navigator.currentScreen {
            case .none:
                self.navigator.currentStack.view(false)
            case let .some(unwrapped):
                unwrapped.view(true)
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
                            self.navigator.currentStack.view(false)
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
                            stack.view(false)
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
        NavigationStackView(stack: [] as [PreviewScreenType], sidebar: { Text("Sidebar") })
    }
}
#endif
