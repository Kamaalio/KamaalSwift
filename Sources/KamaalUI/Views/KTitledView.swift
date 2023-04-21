//
//  KTitledView.swift
//
//
//  Created by Kamaal M Farah on 02/04/2023.
//

import SwiftUI

public struct KTitledView<Content: View>: View {
    let title: String
    let content: () -> Content

    public init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.accentColor)
                .padding(.bottom, -4)
                .padding(.top, 4)
                .ktakeWidthEagerly(alignment: .leading)
            content()
                .ktakeWidthEagerly(alignment: .leading)
            #if os(iOS)
                .padding(.leading, -12)
            #endif
        }
    }
}

struct KTitledView_Previews: PreviewProvider {
    static var previews: some View {
        KTitledView(title: "Title") {
            Text("Text")
        }
    }
}
