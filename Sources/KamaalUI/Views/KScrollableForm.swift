//
//  KScrollableForm.swift
//
//
//  Created by Kamaal M Farah on 17/08/2022.
//

import SwiftUI

/// Makes sure `Form` is scrollable, especially on macOS
public struct KScrollableForm<Content: View>: View {
    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        #if os(macOS)
        ScrollView(.vertical, showsIndicators: true) {
            self.content
        }
        #else
        Form {
            self.content
        }
        #endif
    }
}

struct ScrollableForm_Previews: PreviewProvider {
    static var previews: some View {
        KScrollableForm {
            Text("Text")
        }
    }
}
