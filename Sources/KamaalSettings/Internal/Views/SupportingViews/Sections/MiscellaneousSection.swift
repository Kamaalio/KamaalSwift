//
//  MiscellaneousSection.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalNavigation

struct MiscellaneousSection<ScreenType: NavigatorStackValue>: View {
    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    var body: some View {
        KSection(header: "Miscellaneous".localized(comment: "")) {
            NavigationLinkImageRow(
                localizedLabel: "Logs",
                comment: "",
                imageSystemName: "newspaper.fill",
                destination: self.screenMapping(.logs),
            )
        }
    }
}

// struct MiscellaneousSection_Previews: PreviewProvider {
//    static var previews: some View {
//        MiscellaneousSection()
//    }
// }
