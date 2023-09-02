//
//  KCircularProgressBar.swift
//
//
//  Created by Kamaal Farah on 29/10/2020.
//

import SwiftUI

public struct KCircularProgressBar: View {
    @State private var loaded = false

    public let progress: Double
    public let lineWidth: CGFloat
    public let showProgressText: Bool
    public let animate: Bool

    public init(progress: Double, lineWidth: CGFloat, showProgressText: Bool = true, animate: Bool = true) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.showProgressText = showProgressText
        self.animate = animate
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: self.lineWidth)
                .opacity(0.3)
                .foregroundColor(.accentColor)
            Circle()
                .trim(from: 0, to: CGFloat(self.progress))
                .stroke(style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270))
                .animation(!self.loaded || !self.animate ? nil : .linear)
            if self.showProgressText {
                Text(String(format: "%.0f %%", self.progress * 100))
                    .font(.body)
                    .bold()
            }
        }
        .onAppear(perform: self.onProgressBaraAppear)
    }

    private func onProgressBaraAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loaded = true
        }
    }
}
