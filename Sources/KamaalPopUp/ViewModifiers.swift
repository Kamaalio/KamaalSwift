//
//  ViewModifiers.swift
//
//
//  Created by Kamaal M Farah on 22/12/2021.
//

import SwiftUI
import KamaalUI

extension View {
    @available(macOS 11.0, *)
    public func withKPopUp(@ObservedObject _ manager: KPopUpManager) -> some View {
        ktakeSizeEagerly()
            .kPopUp(
                isPresented: $manager.isShown,
                style: manager.style,
                backgroundColor: manager.config.backgroundColor,
                onClose: manager.hidePopUp
            )
            .environmentObject(manager)
    }

    @available(macOS 11.0, iOS 14, *)
    public func kPopUpLite(
        isPresented: Binding<Bool>,
        style: KPopUpStyles,
        backgroundColor: Color,
        onClose: @escaping () -> Void
    ) -> some View {
        ktakeSizeEagerly()
            .modifier(KPopUpLiteModifier(
                isPresented: isPresented,
                style: style,
                backgroundColor: backgroundColor,
                onClose: onClose
            ))
    }

    @available(macOS 11.0, iOS 14, *)
    public func kPopUpLite(
        isPresented: Binding<Bool>,
        style: KPopUpStyles,
        backgroundColor: Color
    ) -> some View {
        kPopUpLite(isPresented: isPresented, style: style, backgroundColor: backgroundColor, onClose: { })
    }

    @available(macOS 11.0, *)
    fileprivate func kPopUp(
        isPresented: Binding<Bool>,
        style: KPopUpStyles,
        backgroundColor: Color,
        onClose: @escaping () -> Void
    ) -> some View {
        modifier(KPopUpViewModifier(
            isPresented: isPresented,
            style: style,
            backgroundColor: backgroundColor,
            onClose: onClose
        ))
    }
}

@available(macOS 11.0, iOS 14, *)
struct KPopUpLiteModifier: ViewModifier {
    @State private var definitiveIsPresented: Bool

    @Binding var isPresented: Bool

    let style: KPopUpStyles
    let backgroundColor: Color
    let onClose: () -> Void

    init(isPresented: Binding<Bool>, style: KPopUpStyles, backgroundColor: Color, onClose: @escaping () -> Void) {
        self._isPresented = isPresented
        self._definitiveIsPresented = State(initialValue: isPresented.wrappedValue)
        self.style = style
        self.backgroundColor = backgroundColor
        self.onClose = onClose
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: _isPresented.wrappedValue, perform: { newValue in
                if !newValue {
                    close()
                } else {
                    open()
                }
            })
            .onChange(of: definitiveIsPresented, perform: { newValue in
                if !newValue {
                    close()
                } else {
                    open()
                }
            })
            .kPopUp(
                isPresented: $definitiveIsPresented,
                style: style,
                backgroundColor: backgroundColor,
                onClose: close
            )
    }

    private func close() {
        onClose()
        if definitiveIsPresented {
            withAnimation(.easeIn(duration: 0.8)) { definitiveIsPresented = false }
        }
        if isPresented {
            isPresented = false
        }
    }

    private func open() {
        if !definitiveIsPresented {
            withAnimation(.easeOut(duration: 0.5)) { definitiveIsPresented = true }
        }
        if !isPresented {
            isPresented = true
        }
    }
}

@available(macOS 11.0, *)
struct KPopUpViewModifier: ViewModifier {
    @Binding var isPresented: Bool

    let style: KPopUpStyles
    let backgroundColor: Color
    let onClose: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader(content: { geometry in
                if isPresented {
                    KPopupView(style: style, backgroundColor: backgroundColor, onClose: onClose)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: style.alignment)
                }
            }))
    }
}
