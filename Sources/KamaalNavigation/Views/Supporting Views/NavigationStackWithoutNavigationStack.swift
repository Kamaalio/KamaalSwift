//
//  NavigationStackWithoutNavigationStack.swift
//
//
//  Created by Kamaal M Farah on 28/02/2024.
//

import SwiftUI
import KamaalUI

public struct NavigationStackWithoutNavigationStack<Root: View, Screen: NavigatorStackValue>: View {
    @ObservedObject private var navigator: Navigator<Screen>

    let root: (Screen) -> Root

    public init(stack: [Screen], @ViewBuilder root: @escaping (Screen) -> Root) {
        self.root = root
        self._navigator = ObservedObject(wrappedValue: Navigator(stack: stack))
    }

    public var body: some View {
        KJustStack {
            #if os(macOS)
            self.macView
            #else
            self.root(self.navigator.currentStack)
                .navigationDestination(for: Screen.self) { screen in
                    screen.view(true)
                }
            #endif
        }
        .environmentObject(self.navigator)
    }

    private var macView: some View {
        KJustStack {
            switch self.navigator.currentScreen {
            case .none:
                self.root(self.navigator.currentStack)
            case let .some(unwrapped):
                unwrapped.view(true)
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
}

// #Preview {
//    NavigationStackWithoutNavigationStack()
// }
