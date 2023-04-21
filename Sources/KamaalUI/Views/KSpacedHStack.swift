//
//  KSpacedHStack.swift
//  
//
//  Created by Kamaal Farah on 10/09/2021.
//

import SwiftUI

public struct KSpacedHStack<Left: View, Right: View>: View {
    public let left: () -> Left
    public let right: () -> Right

    public init(left: @escaping () -> Left, right: @escaping () -> Right) {
        self.left = left
        self.right = right
    }

    public var body: some View {
        HStack {
            left()
            Spacer()
            right()
        }
    }
}

struct KSpacedHStack_Previews: PreviewProvider {
    static var previews: some View {
        KSpacedHStack(left: {
            Text("Left")
        }, right: {
            Text("Right")
        })
    }
}
