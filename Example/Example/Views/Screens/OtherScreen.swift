//
//  OtherScreen.swift
//  Example
//
//  Created by Kamaal M Farah on 27/04/2023.
//

import SwiftUI
import KamaalNavigation

struct OtherScreen: View {
    var body: some View {
        StackNavigationBackButton(screenType: Screens.self) {
            Text("Back")
        }
    }
}

struct OtherScreen_Previews: PreviewProvider {
    static var previews: some View {
        OtherScreen()
    }
}
