//
//  KJustStack.swift
//  
//
//  Created by Kamaal Farah on 10/09/2021.
//

import SwiftUI

public struct KJustStack<Content: View>: View {
    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
    }
}

struct KJustStack_Previews: PreviewProvider {
    static var previews: some View {
        KJustStack {
            Text("1")
            Text("2")
            Text("3")
            Text("4")
            Text("5")
        }
    }
}
