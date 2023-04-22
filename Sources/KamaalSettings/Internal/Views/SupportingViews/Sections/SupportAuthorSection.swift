//
//  SupportAuthorSection.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalUI

struct SupportAuthorSection: View {
    var body: some View {
        KSection(header: "Support Author".localized(comment: "")) {
            NavigationLinkImageRow(
                localizedLabel: "Buy me coffee",
                comment: "",
                imageSystemName: "cup.and.saucer.fill",
                destination: .supportAuthor
            )
        }
    }
}

struct SupportAuthorSection_Previews: PreviewProvider {
    static var previews: some View {
        SupportAuthorSection()
    }
}
