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
            .foregroundColor(foregroundColor)
            .frame(width: size, height: size)
            .padding(.all, spacing)
            .overlay(
                RoundedRectangle(cornerRadius: size)
                    .stroke(color, lineWidth: borderWidth)
            )
    }

    private var foregroundColor: Color {
        color.opacity(checked ? 1 : 0)
    }
}
