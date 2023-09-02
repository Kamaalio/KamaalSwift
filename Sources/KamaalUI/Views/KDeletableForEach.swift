//
//  KDeletableForEach.swift
//
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

@available(macOS 11.0, *)
struct KDeletableForEach<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let isEditing: Bool
    let deleteText: String
    let onDelete: (Data.Element) -> Void
    let content: (Data.Element) -> Content

    var body: some View {
        ForEach(self.data, id: self.id) { element in
            KDeletableView(
                isDeleting: .constant(false),
                enabled: self.isEditing,
                deleteText: self.deleteText,
                onDelete: { self.onDelete(element) }
            ) {
                self.content(element)
            }
        }
    }
}

// struct KDeletableForEach_Previews: PreviewProvider {
//    static var previews: some View {
//        KDeletableForEach()
//    }
// }
