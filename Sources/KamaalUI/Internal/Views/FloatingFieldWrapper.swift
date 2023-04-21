//
//  FloatingFieldWrapper.swift
//
//
//  Created by Kamaal M Farah on 31/03/2022.
//

import SwiftUI

struct FloatingFieldWrapper<Field: View>: View {
    let text: String
    let title: String
    let field: () -> Field

    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(textColor)
                .offset(y: text.isEmpty ? 0 : -25)
                .scaleEffect(text.isEmpty ? 1 : 0.75, anchor: .leading)
                .padding(.horizontal, titleHorizontalPadding)
            field()
        }
        .padding(.top, 12)
        .animation(.spring(response: 0.5))
    }

    private var textColor: Color {
        if text.isEmpty {
            return .secondary
        }
        return .accentColor
    }

    private var titleHorizontalPadding: CGFloat {
        if text.isEmpty {
            return 4
        }
        return 0
    }
}

#if DEBUG
struct FloatingFieldWrapper_Previews: PreviewProvider {
    typealias PreviewData = FloatingFieldWrapperData

    static var previews: some View {
        ForEach(data, id: \.self) { item in
            // Uses FloatingFieldWrapper
            KFloatingTextField(text: .constant(item.text), title: item.title)
                .frame(width: 200, height: 200)
                .previewLayout(.sizeThatFits)
                .padding(.all, 16)
        }
    }

    static let data: [PreviewData] = [
        .init(text: "text", title: "Title"),
        .init(text: "", title: "Title"),
    ]

    struct FloatingFieldWrapperData: Hashable {
        let text: String
        let title: String
    }
}
#endif
