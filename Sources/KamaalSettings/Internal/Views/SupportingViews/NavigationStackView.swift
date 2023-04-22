//
//  NavigationStackView.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import SwiftUI
import KamaalUI

struct NavigationStackView<Root: View>: View {
    @StateObject private var navigator = Navigator()

    let root: () -> Root

    init(@ViewBuilder root: @escaping () -> Root) {
        self.root = root
    }

    var body: some View {
        #if os(macOS)
        KJustStack {
            switch navigator.currentScreen {
            case .none:
                root()
            case let .some(unwrapped):
                MainView(screen: unwrapped)
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
        .environmentObject(navigator)
        #else
        root()
        #endif
    }
}

struct NavigationStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackView {
            Text("Content")
        }
    }
}
