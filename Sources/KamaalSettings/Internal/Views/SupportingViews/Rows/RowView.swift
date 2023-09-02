//
//  RowView.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI

struct RowView<Label: View, Value: View>: View {
    let label: Label
    let value: Value

    init(@ViewBuilder label: () -> Label, @ViewBuilder value: () -> Value) {
        self.label = label()
        self.value = value()
    }

    var body: some View {
        HStack {
            self.label
                .font(.headline)
            Spacer()
            self.value
        }
        .padding(.vertical, 1)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(label: { Text("Label") }, value: { Text("Value") })
    }
}
