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
            if enabled && !isDeleting {
                Button(action: { withAnimation { isDeleting = true } }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .padding(.leading, 20)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.move(edge: .leading))
            }
            content()
            if enabled && isDeleting {
                Spacer()
                Button(action: _onDelete) {
                    ZStack {
                        Color.red
                        Text(deleteText)
                            .foregroundColor(light: .white, dark: .black)
                            .kBindToFrameSize($textSize)
                    }
                    .frame(minWidth: deleteButtonWidth,
                           maxWidth: deleteButtonWidth,
                           minHeight: deleteButtonHeight,
                           maxHeight: deleteButtonHeight)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.move(edge: .trailing))
            }
        }
        .ktakeWidthEagerly(alignment: .leading)
    }

    private var deleteButtonWidth: CGFloat {
        textSize.width + 16
    }

    private var deleteButtonHeight: CGFloat {
        textSize.height + 16
    }

    private func _onDelete() {
        onDelete()
        withAnimation { isDeleting = false }
    }
}

public extension View {
    @available(macOS 11.0, *)
    func kDeletableView(isDeleting: Binding<Bool>, enabled: Bool, onDelete: @escaping () -> Void) -> some View {
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
