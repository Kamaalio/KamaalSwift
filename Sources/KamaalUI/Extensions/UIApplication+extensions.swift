//
//  UIApplication+extensions.swift
//  KamaalUI
//
//  Created by Kamaal Farah on 07/05/2020.
//

import SwiftUI

#if !os(macOS) && !os(watchOS)
extension UIApplication {
    public func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#if os(macOS)
extension NSApplication {
    public func endEditing() {
        sendAction(#selector(NSResponder.resignFirstResponder), to: nil, from: nil)
    }
}
#endif
