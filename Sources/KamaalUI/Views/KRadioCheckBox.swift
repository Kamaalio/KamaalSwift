//
//  KRadioCheckBox.swift
//  KamaalUI
//
//  Created by Kamaal Farah on 06/05/2020.
//

import SwiftUI

public struct KRadioCheckBox: View {
    public var checked: Bool
    public var color: Color
    public var size: CGFloat
    public var borderWidth: CGFloat
    public var spacing: CGFloat

    public init(checked: Bool, color: Color = .accentColor, size: CGFloat, borderWidth: CGFloat, spacing: CGFloat) {
        self.checked = checked
        self.color = color
        self.size = size
        self.borderWidth = borderWidth
        self.spacing = spacing
    }

    public init(checked: Bool, color: Color = .accentColor, size: CGFloat) {
        self.checked = checked
        self.color = color
        self.size = size
        self.borderWidth = size / 10
        self.spacing = size / 10
    }

    public var body: some View {
        Circle()
            .foregroundColor(self.foregroundColor)
            .frame(width: self.size, height: self.size)
            .padding(.all, self.spacing)
            .overlay(
                RoundedRectangle(cornerRadius: self.size)
                    .stroke(self.color, lineWidth: self.borderWidth)
            )
    }

    private var foregroundColor: Color {
        self.color.opacity(self.checked ? 1 : 0)
    }
}
