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
        content.background(self.resolvedColor)
    }

    private var resolvedColor: Color {
        switch self.colorScheme {
        case .light: return self.lightModeColor
        case .dark: return self.darkModeColor
        @unknown default: return self.lightModeColor
        }
    }
}

extension View {
    public func backgroundColor(light lightModeColor: Color, dark darkModeColor: Color) -> some View {
        modifier(AdaptiveBackgroundColorModifier(lightModeColor: lightModeColor, darkModeColor: darkModeColor))
    }
}
