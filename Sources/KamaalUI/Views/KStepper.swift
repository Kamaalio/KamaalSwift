//
//  KStepper.swift
//
//
//  Created by Kamaal Farah on 29/10/2020.
//

#if !os(watchOS)
import SwiftUI

@available(iOS 13.0, OSX 11.0, *)
public struct KStepper: View {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    @State private var incrementOpacity = 1.0
    @State private var decrementOpacity = 1.0
    #endif

    public let size: CGSize
    public let disableIncrement: Bool
    public let disableDecrement: Bool
    public let onIncrement: () -> Void
    public let onDecrement: () -> Void

    public init(size: CGSize,
                disableIncrement: Bool = false,
                disableDecrement: Bool = false,
                onIncrement: @escaping () -> Void,
                onDecrement: @escaping () -> Void) {
        self.size = size
        self.disableIncrement = disableIncrement
        self.disableDecrement = disableDecrement
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
    }

    #if os(iOS) && !targetEnvironment(macCatalyst)
    public var body: some View {
        HStack {
            Image(systemName: "minus.rectangle.fill")
                .kSize(size)
                .opacity(decrementOpacity)
                .disabled(disableDecrement)
                .onTapGesture(perform: {
                    if !disableDecrement {
                        decrementOpacity = 0.2
                        onDecrement()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation { decrementOpacity = 1 }
                        }
                    }
                })
            Image(systemName: "plus.rectangle.fill")
                .kSize(size)
                .opacity(incrementOpacity)
                .disabled(disableIncrement)
                .onTapGesture(perform: {
                    if !disableIncrement {
                        incrementOpacity = 0.2
                        onIncrement()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation { incrementOpacity = 1 }
                        }
                    }
                })
        }
        .foregroundColor(.accentColor)
    }

    #elseif targetEnvironment(macCatalyst)
    public var body: some View {
        HStack {
            Button(action: onDecrement) {
                Image(systemName: "minus.rectangle.fill")
                    .kSize(size)
                    .foregroundColor(.accentColor)
            }
            .disabled(disableDecrement)
            Button(action: onIncrement) {
                Image(systemName: "plus.rectangle.fill")
                    .kSize(size)
                    .foregroundColor(.accentColor)
            }
            .disabled(disableIncrement)
        }
    }

    #elseif os(macOS)
    public var body: some View {
        HStack {
            Button(action: onDecrement) {
                Image(systemName: "minus.rectangle.fill")
                    .kSize(size)
                    .foregroundColor(.accentColor)
            }
            .disabled(disableDecrement)
            .buttonStyle(PlainButtonStyle())
            Button(action: onIncrement) {
                Image(systemName: "plus.rectangle.fill")
                    .kSize(size)
                    .foregroundColor(.accentColor)
            }
            .disabled(disableIncrement)
            .buttonStyle(PlainButtonStyle())
        }
    }
    #endif
}
#endif
