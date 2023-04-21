//
//  Image+extensions.swift
//
//
//  Created by Kamaal Farah on 29/10/2020.
//

import SwiftUI

extension Image {
    public func kSize(_ imageSize: CGSize) -> some View {
        resizable()
            .frame(width: imageSize.width, height: imageSize.height)
    }

    public func kBold() -> some View {
        modifier(ImageBoldViewModifier(font: .body))
    }

    public func kBold(_ font: Font) -> some View {
        modifier(ImageBoldViewModifier(font: font))
    }
}

private struct ImageBoldViewModifier: ViewModifier {
    let font: Font

    func body(content: Content) -> some View {
        content.font(font.bold())
    }
}
