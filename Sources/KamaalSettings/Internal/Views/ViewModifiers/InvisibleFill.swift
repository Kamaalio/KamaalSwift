//
//  InvisibleFill.swift
//
//
//  Created by Kamaal Farah on 24/12/2022.
//

import SwiftUI
import KamaalUI

extension View {
    func invisibleFill() -> some View {
        ktakeWidthEagerly()
        #if os(macOS)
            .background(Color(nsColor: .separatorColor).opacity(0.01))
        #else
            .background(Color(uiColor: .separator).opacity(0.01))
        #endif
    }
}
