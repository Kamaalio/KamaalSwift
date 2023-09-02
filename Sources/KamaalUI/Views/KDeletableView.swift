//
//  KDeletableView.swift
//
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

@available(macOS 11.0, *)
public struct KDeletableView<Content: View>: View {
    @State private var textSize = CGSize(width: 60, height: 60)

    @Binding public var isDeleting: Bool

    public let enabled: Bool
    public let deleteText: String
    public let onDelete: () -> Void
    public let content: () -> Content

    public init(isDeleting: Binding<Bool>,
                enabled: Bool,
                deleteText: String = "Delete",
                onDelete: @escaping () -> Void,
                content: @escaping () -> Content) {
        self._isDeleting = isDeleting
        self.enabled = enabled
        self.deleteText = deleteText
        self.onDelete = onDelete
        self.content = content
    }

    public var body: some View {
        HStack {
            if self.enabled, !self.isDeleting {
                Button(action: { withAnimation { self.isDeleting = true } }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .padding(.leading, 20)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.move(edge: .leading))
            }
            self.content()
            if self.enabled, self.isDeleting {
                Spacer()
                Button(action: self._onDelete) {
                    ZStack {
                        Color.red
                        Text(self.deleteText)
                            .foregroundColor(light: .white, dark: .black)
                            .kBindToFrameSize(self.$textSize)
                    }
                    .frame(minWidth: self.deleteButtonWidth,
                           maxWidth: self.deleteButtonWidth,
                           minHeight: self.deleteButtonHeight,
                           maxHeight: self.deleteButtonHeight)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.move(edge: .trailing))
            }
        }
        .ktakeWidthEagerly(alignment: .leading)
    }

    private var deleteButtonWidth: CGFloat {
        self.textSize.width + 16
    }

    private var deleteButtonHeight: CGFloat {
        self.textSize.height + 16
    }

    private func _onDelete() {
        self.onDelete()
        withAnimation { self.isDeleting = false }
    }
}

extension View {
    @available(macOS 11.0, *)
    public func kDeletableView(isDeleting: Binding<Bool>, enabled: Bool, onDelete: @escaping () -> Void) -> some View {
        KDeletableView(isDeleting: isDeleting, enabled: enabled, onDelete: onDelete, content: { self })
    }
}

@available(macOS 11.0, *)
struct KDeletableView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Yes delete me")
            .kDeletableView(isDeleting: .constant(true), enabled: true, onDelete: { })
    }
}
