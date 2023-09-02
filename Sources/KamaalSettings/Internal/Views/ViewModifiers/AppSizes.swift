//
//  AppSizes.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI

extension View {
    func padding(_ edges: Edge.Set = .all, _ length: AppSizes) -> some View {
        self.padding(edges, length.rawValue)
    }

    func cornerRadius(_ length: AppSizes) -> some View {
        self.cornerRadius(length.rawValue)
    }
}

enum AppSizes: CGFloat {
    /// Size of 0
    case nada = 0
    /// Size of 2
    case extraExtraSmall = 2
    /// Size of 4
    case extraSmall = 4
    /// Size of 8
    case small = 8
    /// Size of 16
    case medium = 16
    /// Size of 24
    case large = 24
    /// Size of 32
    case extraLarge = 32
}
