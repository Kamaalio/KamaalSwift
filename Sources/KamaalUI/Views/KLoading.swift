//
//  KLoading.swift
//  KamaalUI
//
//  Created by Kamaal Farah on 07/05/2020.
//

import SwiftUI

public struct KLoading: View {
    public init() { }

    public var body: some View {
        #if os(macOS)
        KActivityIndicator(isAnimating: .constant(true), style: .spinning)
        #else
        KActivityIndicator(isAnimating: .constant(true), style: .large)
        #endif
    }
}

#if !os(macOS)
struct KActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    var style: UIActivityIndicatorView.Style

    init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style) {
        self._isAnimating = isAnimating
        self.style = style
    }

    func makeUIView(context: UIViewRepresentableContext<KActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<KActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
#endif

#if os(macOS)
struct KActivityIndicator: NSViewRepresentable {
    @Binding var isAnimating: Bool

    var style: NSProgressIndicator.Style

    init(isAnimating: Binding<Bool>, style: NSProgressIndicator.Style) {
        self._isAnimating = isAnimating
        self.style = style
    }

    func makeNSView(context: Context) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.style = style
        return progressIndicator
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        isAnimating ? nsView.startAnimation(nil) : nsView.stopAnimation(nil)
    }
}
#endif
