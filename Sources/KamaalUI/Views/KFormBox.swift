//
//  KFormBox.swift
//  KamaalSwift
//
//  Created by Kamaal M Farah on 10/12/25.
//

import SwiftUI

public struct KFormBox<Content: View>: View {
    private let title: String
    private let minSize: CGSize

    @ViewBuilder private let content: () -> Content

    public init(title: String, minSize: CGSize, content: @escaping () -> Content) {
        self.title = title
        self.minSize = minSize
        self.content = content
    }

    public init(
        localizedTitle: LocalizedStringResource,
        bundle: Bundle,
        minSize: CGSize,
        content: @escaping () -> Content,
    ) {
        self.init(
            title: NSLocalizedString(localizedTitle.key, bundle: bundle, comment: ""),
            minSize: minSize,
            content: content,
        )
    }

    public var body: some View {
        VStack {
            GroupBox {
                VStack {
                    Text(self.title)
                        .font(.title2)
                        .ktakeWidthEagerly(alignment: .leading)
                    self.content()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
            }
            .frame(width: self.minSize.width / 1.1)
        }
        .padding(.horizontal, 8)
        .frame(minWidth: self.minSize.width + 8, minHeight: self.minSize.height + 8)
        .navigationTitle(Text(self.title))
    }
}

#Preview {
    KFormBox(title: "FormBox", minSize: .init(width: 200, height: 200)) {
        Text("Gello")
    }
}
