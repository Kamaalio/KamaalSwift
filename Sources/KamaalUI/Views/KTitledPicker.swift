//
//  KTitledPicker.swift
//
//
//  Created by Kamaal M Farah on 28/11/2023.
//

import SwiftUI

public struct KTitledPicker<Item: Hashable, PickerItemView: View>: View {
    @Binding var selection: Item?

    let title: String
    let items: [Item]
    let pickerItemView: (_ item: Item) -> PickerItemView

    public init(
        selection: Binding<Item?>,
        title: String,
        items: [Item],
        @ViewBuilder pickerItemView: @escaping (_ item: Item) -> PickerItemView
    ) {
        self._selection = selection
        self.title = title
        self.items = items
        self.pickerItemView = pickerItemView
    }

    public var body: some View {
        KTitledView(title: self.title) {
            Picker("", selection: self.$selection) {
                ForEach(self.items, id: \.self) { item in
                    self.pickerItemView(item)
                        .tag(item)
                }
            }
            .labelsHidden()
        }
    }
}

struct KTitledPicker_Previews: PreviewProvider {
    static var previews: some View {
        KTitledPicker(selection: .constant(1), title: "One Or Two", items: [1, 2]) { item in
            Text("\(item)")
        }
    }
}
