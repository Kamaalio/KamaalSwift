//
//  KSection.swift
//
//
//  Created by Kamaal M Farah on 17/08/2022.
//

import SwiftUI

public struct KSection<Content: View>: View {
    public let header: String?
    public let content: Content

    public init(header: String? = nil, @ViewBuilder content: () -> Content) {
        self.header = header?.uppercased()
        self.content = content()
    }

    public var body: some View {
        KJustStack {
            if let header = header {
                #if os(macOS)
                VStack {
                    Text(header)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .ktakeWidthEagerly(alignment: .leading)
                    content
                }
                #else
                Section(header: Text(header)) {
                    content
                }
                #endif
            } else {
                #if os(macOS)
                content
                #else
                Section {
                    content
                }
                #endif
            }
        }
        #if os(macOS)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(nsColor: .separatorColor))
        .cornerRadius(8)
        #endif
    }
}

struct KSection_Previews: PreviewProvider {
    static var previews: some View {
        KSection(header: "Header") {
            Text("Text")
        }
    }
}
