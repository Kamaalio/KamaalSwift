//
//  HudPopupView.swift
//
//
//  Created by Kamaal M Farah on 17/01/2022.
//

import SwiftUI
import KamaalUI

@available(macOS 11.0, *)
struct HudPopupView: View {
    @State private var offset: CGSize = .zero

    let title: String
    let description: String?
    let systemImageName: String?
    let backgroundColor: Color
    let onClose: () -> Void

    var body: some View {
        KJustStack {
            HStack {
                if let systemImageName = systemImageName {
                    Image(systemName: systemImageName)
                        .kSize(Self.imageSize)
                }
                VStack {
                    Text(title)
                    if let description = description {
                        Text(description)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                Text("")
                    .frame(width: Self.imageSize.width, height: Self.imageSize.height)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(backgroundColor)
            .cornerRadius(24)
        }
        .ktakeWidthEagerly(alignment: .center)
        .padding(.top, 8)
        .transition(.move(edge: .top))
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged(onDrag(_:))
                .onEnded(onDragEnd(_:))
        )
    }

    private func onDrag(_ value: DragGesture.Value) {
        let newHeight = value.translation.height
        guard newHeight <= 0 else { return }
        offset = CGSize(width: offset.width, height: value.translation.height)
    }

    private func onDragEnd(_: DragGesture.Value) {
        if offset.height < -12 {
            onClose()
        } else {
            offset = .zero
        }
    }

    private static let imageSize = CGSize(width: 14, height: 14)
}

struct HudPopupView_Previews: PreviewProvider {
    static var previews: some View {
        HudPopupView(
            title: "Title",
            description: "Description",
            systemImageName: "person",
            backgroundColor: KPopUpManager().config.backgroundColor,
            onClose: { }
        )
    }
}
