//
//  BottomPopupView.swift
//
//
//  Created by Kamaal M Farah on 17/01/2022.
//

import SwiftUI
import KamaalUI

@available(macOS 11.0, *)
struct BottomPopupView: View {
    let title: String
    let description: String?
    let backgroundColor: Color
    let bottomType: KPopUpBottomType?
    let close: () -> Void

    init(
        title: String,
        description: String?,
        backgroundColor: Color,
        bottomType: KPopUpBottomType?,
        close: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.backgroundColor = backgroundColor
        self.bottomType = bottomType
        self.close = close
    }

    var body: some View {
        KJustStack {
            HStack(alignment: .top) {
                if let bottomType {
                    Image(systemName: bottomType.iconName)
                        .foregroundColor(bottomType.color)
                    VStack(alignment: .leading) {
                        Text(title)
                            .foregroundColor(bottomType.color)
                            .bold()
                        if let description {
                            Text(description)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Spacer()
                Button(action: close) {
                    Image(systemName: "xmark")
                        .kBold()
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.all, 16)
        }
        .ktakeWidthEagerly(alignment: .center)
        .background(backgroundColor)
        .cornerRadius(8)
        .padding(.bottom, 8)
        .transition(.move(edge: .bottom))
    }
}

@available(macOS 11.0, *)
struct BottomPopupView_Previews: PreviewProvider {
    static var previews: some View {
        BottomPopupView(
            title: "Title",
            description: "Description",
            backgroundColor: KPopUpConfig().backgroundColor,
            bottomType: .error, close: { }
        )
    }
}
