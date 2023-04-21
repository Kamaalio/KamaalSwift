//
//  KTextView.swift
//
//
//  Created by Kamaal M Farah on 30/03/2022.
//

import SwiftUI

#if canImport(UIKit) || canImport(Cocoa)
public struct KTextView: View {
    @Binding var text: String

    let title: String

    public init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }

    public var body: some View {
        VStack {
            Text(title)
                .foregroundColor(.accentColor)
                .offset(y: 8)
                .ktakeWidthEagerly(alignment: .leading)
            TextViewRepresentable(text: $text)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 1))
        }
    }
}

#if DEBUG
struct KTextView_Previews: PreviewProvider {
    typealias PreviewData = KTextViewData

    static var previews: some View {
        ForEach(data, id: \.self) { item in
            KTextView(text: .constant(item.text), title: item.title)
                .frame(width: 200, height: 200)
                .previewLayout(.sizeThatFits)
                .padding(.all, 16)
        }
    }

    static let data: [PreviewData] = [
        .init(text: "something\nsomething\nview.", title: "Title"),
    ]

    struct KTextViewData: Hashable {
        let text: String
        let title: String
    }
}
#endif
#endif
