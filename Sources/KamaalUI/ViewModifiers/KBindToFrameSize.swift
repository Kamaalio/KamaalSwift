//
//  KBindToFrameSize.swift
//
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

extension View {
    public func kBindToFrameSize(_ size: Binding<CGSize>) -> some View {
        modifier(KBindToFrameSize(size: size))
    }
}

private struct KBindToFrameSize: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content.overlay(GeometryReader(content: self.overlay(for:)))
    }

    func overlay(for geometry: GeometryProxy) -> some View {
        let size = geometry.size
        if self.size.width != size.width || self.size.height != size.height {
            DispatchQueue.main.async {
                self.size = geometry.size
            }
        }
        return Text("")
    }
}
