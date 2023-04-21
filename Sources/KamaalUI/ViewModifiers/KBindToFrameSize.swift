//
//  KBindToFrameSize.swift
//  
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

public extension View {
    func kBindToFrameSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(KBindToFrameSize(size: size))
    }
}

private struct KBindToFrameSize: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content.overlay(GeometryReader(content: overlay(for:)))
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
