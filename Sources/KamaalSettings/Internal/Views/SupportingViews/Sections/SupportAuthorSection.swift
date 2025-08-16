//
//  SupportAuthorSection.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

struct SupportAuthorSection<ScreenType: NavigatorStackValue>: View {
    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    var body: some View {
        KSection(header: "Support Author".localized(comment: "")) {
            NavigationLinkImageRow(
                localizedLabel: "Buy me coffee",
                comment: "",
                imageSystemName: "cup.and.saucer.fill",
                destination: self.screenMapping(.supportAuthor),
            )
        }
    }
}

// struct SupportAuthorSection_Previews: PreviewProvider {
//    static var previews: some View {
//        SupportAuthorSection()
//    }
// }
