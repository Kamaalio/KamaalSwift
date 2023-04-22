//
//  ValueRow.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI

struct ValueRow<Value: View>: View {
    let label: String
    let value: Value

    init(label: String, @ViewBuilder value: () -> Value) {
        self.label = label
        self.value = value()
    }

    init(localizedLabel: String, comment: String, @ViewBuilder value: () -> Value) {
        self.init(label: localizedLabel.localized(comment: comment), value: value)
    }

    var body: some View {
        RowView(label: {
            AppText(string: label)
        }, value: {
            value
        })
    }
}

struct ValueRow_Previews: PreviewProvider {
    static var previews: some View {
        ValueRow(label: "Label", value: { Text("Value") })
    }
}
