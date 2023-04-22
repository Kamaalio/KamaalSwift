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
    public init(backgroundColor: Color = Color(UIColor.secondarySystemBackground)) {
        self.backgroundColor = backgroundColor
    }
    #else
    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }

    public init() {
        self.init(backgroundColor: Color("BackgroundColor", bundle: .module))
    }
    #endif
}
