//
//  AdaptiveForegroundColorModifier.swift
//
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

private struct AdaptiveForegroundColorModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    var lightModeColor: Color
    var darkModeColor: Color

    func body(content: Content) -> some View {
        content.foregroundColor(self.resolvedColor)
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
    public func foregroundColor(light lightModeColor: Color, dark darkModeColor: Color) -> some View {
        modifier(AdaptiveForegroundColorModifier(lightModeColor: lightModeColor, darkModeColor: darkModeColor))
    }
}
