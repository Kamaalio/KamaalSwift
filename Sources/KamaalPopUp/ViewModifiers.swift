//
//  ViewModifiers.swift
//
//
//  Created by Kamaal M Farah on 22/12/2021.
//

import SwiftUI
import KamaalUI

extension View {
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

    public func kPopUpLite(
        isPresented: Binding<Bool>,
        style: KPopUpStyles,
        backgroundColor: Color
    ) -> some View {
        self.kPopUpLite(isPresented: isPresented, style: style, backgroundColor: backgroundColor, onClose: { })
    }

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
                    self.close()
                } else {
                    self.open()
                }
            })
            .onChange(of: self.definitiveIsPresented, perform: { newValue in
                if !newValue {
                    self.close()
                } else {
                    self.open()
                }
            })
            .kPopUp(
                isPresented: self.$definitiveIsPresented,
                style: self.style,
                backgroundColor: self.backgroundColor,
                onClose: self.close
            )
    }

    private func close() {
        self.onClose()
        if self.definitiveIsPresented {
            withAnimation(.easeIn(duration: 0.8)) { self.definitiveIsPresented = false }
        }
        if self.isPresented {
            self.isPresented = false
        }
    }

    private func open() {
        if !self.definitiveIsPresented {
            withAnimation(.easeOut(duration: 0.5)) { self.definitiveIsPresented = true }
        }
        if !self.isPresented {
            self.isPresented = true
        }
    }
}

struct KPopUpViewModifier: ViewModifier {
    @Binding var isPresented: Bool

    let style: KPopUpStyles
    let backgroundColor: Color
    let onClose: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader(content: { geometry in
                if self.isPresented {
                    KPopupView(style: self.style, backgroundColor: self.backgroundColor, onClose: self.onClose)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: self.style.alignment
                        )
                }
            }))
    }
}
