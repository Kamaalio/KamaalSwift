//
//  NavigationLinkColorRow.swift
//
//
//  Created by Kamaal M Farah on 22/12/2022.
//

import SwiftUI

struct NavigationLinkColorRow: View {
    let label: String
    let color: Color
    let destination: ScreenSelection

    init(label: String, color: Color, destination: ScreenSelection) {
        self.label = label
        self.color = color
        self.destination = destination
    }

    init(localizedLabel: String, comment _: String, color: Color, destination: ScreenSelection) {
        self.init(label: localizedLabel.localized(comment: ""), color: color, destination: destination)
    }

    var body: some View {
        NavigationLinkRow(destination: self.destination) {
            ColorTextRow(label: self.label, color: self.color)
        }
    }
}

struct NavigationLinkColorRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLinkColorRow(label: "Label", color: .accentColor, destination: .appIcon)
    }
}
