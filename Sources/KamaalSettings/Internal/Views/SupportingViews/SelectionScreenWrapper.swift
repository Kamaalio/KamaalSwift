//
//  SelectionScreenWrapper.swift
//
//
//  Created by Kamaal Farah on 24/12/2022.
//

import SwiftUI
import KamaalUI

struct SelectionScreenWrapper<Row: View, Item: Hashable & Identifiable>: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    let navigationTitle: String
    let sectionTitle: String
    let items: [Item]
    let onItemPress: (_ item: Item) -> Void
    let row: (Item) -> Row

    init(
        navigationTitle: String,
        sectionTitle: String,
        items: [Item],
        onItemPress: @escaping (Item) -> Void,
        @ViewBuilder row: @escaping (Item) -> Row
    ) {
        self.navigationTitle = navigationTitle
        self.sectionTitle = sectionTitle
        self.items = items
        self.onItemPress = onItemPress
        self.row = row
    }

    var body: some View {
        KScrollableForm {
            KSection(header: sectionTitle) {
                ForEach(items) { item in
                    AppButton(action: { onItemPress(item) }) {
                        row(item)
                    }
                    #if os(macOS)
                    if item != items.last {
                        Divider()
                    }
                    #endif
                }
            }
            #if os(macOS)
            .padding(.all, .medium)
            #endif
        }
        .ktakeSizeEagerly(alignment: .topLeading)
        .navigationTitle(title: navigationTitle, displayMode: .inline)
        .accentColor(settingsConfiguration.currentColor)
    }
}

struct SelectionScreenWrapper_Previews: PreviewProvider {
    static var previews: some View {
        SelectionScreenWrapper(
            navigationTitle: "Title",
            sectionTitle: "Section",
            items: [
                AppColor(id: UUID(uuidString: "15a20957-1d37-49bb-b463-b5a3cd5efd79")!, name: "Red", color: .red),
                AppColor(id: UUID(uuidString: "c7fffbb9-28de-4b93-a7a8-d065ea57ad0b")!, name: "Green", color: .green),
            ],
            onItemPress: { _ in }
        ) { item in
            Text(item.name)
        }
    }
}
