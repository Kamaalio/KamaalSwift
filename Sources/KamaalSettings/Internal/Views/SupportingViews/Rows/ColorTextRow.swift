//
//  ColorTextRow.swift
//
//
//  Created by Kamaal M Farah on 22/12/2022.
//

import SwiftUI
import KamaalExtensions

struct ColorTextRow: View {
    let label: String
    let color: Color

    init(label: String, color: Color) {
        self.label = label
        self.color = color
    }

    var body: some View {
        ValueRow(label: self.label) {
            self.color
                .frame(width: Constants.rowTileSize.width, height: Constants.rowTileSize.height)
                .cornerRadius(Constants.rowTileCornerRadius)
        }
    }
}

struct ColorTextRow_Previews: PreviewProvider {
    static var previews: some View {
        ColorTextRow(label: "Label", color: .accentColor)
    }
}
