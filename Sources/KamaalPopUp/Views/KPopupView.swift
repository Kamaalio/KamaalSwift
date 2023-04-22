//
//  KPopupView.swift
//
//
//  Created by Kamaal M Farah on 22/12/2021.
//

import SwiftUI

@available(macOS 11.0, *)
struct KPopupView: View {
    let style: KPopUpStyles
    let backgroundColor: Color
    let onClose: () -> Void

    var body: some View {
        switch style {
        case let .bottom(title, type, description):
            BottomPopupView(
                title: title,
                description: description,
                backgroundColor: backgroundColor,
                bottomType: type,
                close: onClose
            )
        case let .hud(title, systemImageName, description):
            HudPopupView(
                title: title,
                description: description,
                systemImageName: systemImageName,
                backgroundColor: backgroundColor,
                onClose: onClose
            )
        }
    }
}

@available(macOS 11.0, *)
struct KPopupView_Previews: PreviewProvider {
    static var previews: some View {
        KPopupView(style: .bottom(title: "Title", type: .success, description: "Description"),
                   backgroundColor: KPopUpManager().config.backgroundColor,
                   onClose: { })
    }
}
