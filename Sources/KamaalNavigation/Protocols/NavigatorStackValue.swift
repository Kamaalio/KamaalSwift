//
//  NavigatorStackValue.swift
//
//
//  Created by Kamaal M Farah on 04/01/2023.
//

import SwiftUI
import KamaalUI

public protocol NavigatorStackValue: Codable, Hashable, CaseIterable {
    associatedtype ScreenView: SwiftUI.View

    var isTabItem: Bool { get }
    var imageSystemName: String { get }
    var title: String { get }

    @ViewBuilder
    @MainActor
    func view(_ isSub: Bool) -> Self.ScreenView

    static var root: Self { get }
}

#if DEBUG
enum PreviewScreenType: NavigatorStackValue, Equatable {
    case screen
    case sub

    var isTabItem: Bool { true }
    var isSidebarItem: Bool { true }
    var imageSystemName: String { "person" }
    var title: String { "Screen" }

    func view(_ isSub: Bool) -> some View {
        KJustStack {
            switch self {
            case .screen: Text("Screen").navigationTitle(title: "Screen", displayMode: isSub ? .inline : .large)
            case .sub: Text("Sub").navigationTitle(title: "Sub", displayMode: isSub ? .inline : .large)
            }
        }
    }

    static let root: Self = .screen
}
#endif
