//
//  NavigationLinkValueRow.swift
//
//
//  Created by Kamaal M Farah on 29/05/2023.
//

import SwiftUI
import KamaalNavigation

struct NavigationLinkValueRow<Value: View, ScreenType: NavigatorStackValue>: View {
    let label: String
    let value: Value
    let destination: ScreenType

    init(label: String, destination: ScreenType, @ViewBuilder value: () -> Value) {
        self.label = label
        self.value = value()
        self.destination = destination
    }

    init(localizedLabel: String, comment: String, destination: ScreenType, @ViewBuilder value: () -> Value) {
        self.init(label: localizedLabel.localized(comment: comment), destination: destination, value: value)
    }

    var body: some View {
        NavigationLinkRow(destination: self.destination) {
            ValueRow(label: self.label) {
                self.value
            }
        }
    }
}

// struct NavigationLinkValueRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationLinkValueRow(label: "Label", destination: .appColor) {
//            AppText(string: "Hello")
//        }
//    }
// }
