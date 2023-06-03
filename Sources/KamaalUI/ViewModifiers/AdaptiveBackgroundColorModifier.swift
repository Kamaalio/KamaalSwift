//
//  AdaptiveBackgroundColorModifier.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import SwiftUI

private struct AdaptiveBackgroundColorModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    var lightModeColor: Color
    var darkModeColor: Color

    func body(content: Content) -> some View {
        content.background(resolvedColor)
    }

    private var resolvedColor: Color {
        switch colorScheme {
        case .light: return lightModeColor
        case .dark: return darkModeColor
        @unknown default: return lightModeColor
        }
    }
}

extension View {
    public func backgroundColor(light lightModeColor: Color, dark darkModeColor: Color) -> some View {
        modifier(AdaptiveBackgroundColorModifier(lightModeColor: lightModeColor, darkModeColor: darkModeColor))
    }
}
