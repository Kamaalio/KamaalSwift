//
//  StackNavigationBackButton.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI

public struct StackNavigationBackButton<Destination: NavigatorStackValue, Content: View>: View {
    @EnvironmentObject private var navigator: Navigator<Destination>

    let content: () -> Content

    public init(screenType _: Destination.Type, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Button(action: { self.navigator.goBack() }) {
            self.content()
        }
    }
}

#if DEBUG
struct StackNavigationBackButton_Previews: PreviewProvider {
    static var previews: some View {
        StackNavigationBackButton(screenType: PreviewScreenType.self) {
            Text("Go back")
        }
    }
}
#endif
