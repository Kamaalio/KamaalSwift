//
//  StackNavigationLink.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI

public struct StackNavigationLink<Content: View, Destination: NavigatorStackValue>: View {
    @EnvironmentObject private var navigator: Navigator<Destination>

    let destination: Destination
    let content: () -> Content

    public init(destination: Destination, @ViewBuilder content: @escaping () -> Content) {
        self.destination = destination
        self.content = content
    }

    public var body: some View {
        #if os(macOS)
        Button(action: { self.navigator.navigate(to: self.destination) }) {
            self.content()
        }
        #else
        NavigationLink(value: self.destination) {
            self.content()
        }
        #endif
    }
}

#if DEBUG
struct StackNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        StackNavigationLink(destination: PreviewScreenType.screen) {
            Text("Link")
        }
    }
}
#endif
