//
//  KPopUpConfig.swift
//
//
//  Created by Kamaal M Farah on 22/12/2021.
//

import SwiftUI

public struct KPopUpConfig {
    public let backgroundColor: Color

    #if canImport(UIKit)
    /// Creates a config with an optional background color (defaults to system secondary background).
    public init(backgroundColor: Color = Color(UIColor.secondarySystemBackground)) {
        self.backgroundColor = backgroundColor
    }
    #else
    /// Creates a config specifying a background color (non-UIKit platforms).
    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }

    /// Creates a config with a module-defined background color asset.
    public init() {
        self.init(backgroundColor: Color("BackgroundColor", bundle: .module))
    }
    #endif
}
