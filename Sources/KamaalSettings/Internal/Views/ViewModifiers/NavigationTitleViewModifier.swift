//
//  NavigationTitleViewModifier.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI

extension View {
    func navigationTitle(title: String, displayMode: DisplayMode) -> some View {
        modifier(NavigationTitleViewModifier(title: title, displayMode: displayMode))
    }

    func navigationTitle(localizedTitle: String, comment: String, displayMode: DisplayMode) -> some View {
        navigationTitle(
            title: NSLocalizedString(localizedTitle, bundle: .module, comment: comment),
            displayMode: displayMode
        )
    }
}

enum DisplayMode {
    case large
    case inline

    #if os(iOS)
    var navigationBarItemDisplayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .large:
            return .large
        case .inline:
            return .inline
        }
    }
    #endif
}

private struct NavigationTitleViewModifier: ViewModifier {
    let title: String
    let displayMode: DisplayMode

    init(title: String, displayMode: DisplayMode) {
        self.title = title
        self.displayMode = displayMode
    }

    init(localizedTitle: String, comment: String, displayMode: DisplayMode) {
        self.init(title: NSLocalizedString(localizedTitle, bundle: .module, comment: comment), displayMode: displayMode)
    }

    func body(content: Content) -> some View {
        content
            .navigationTitle(AppText(string: title))
        #if os(iOS)
            .navigationBarTitleDisplayMode(displayMode.navigationBarItemDisplayMode)
        #endif
    }
}
