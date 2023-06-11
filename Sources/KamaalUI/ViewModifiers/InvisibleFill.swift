//
//  InvisibleFill.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

#if !os(watchOS)
import SwiftUI

extension View {
    public func kInvisibleFill() -> some View {
        ktakeWidthEagerly()
        #if os(macOS)
            .background(Color(nsColor: .separatorColor).opacity(0.01))
        #else
            .background(Color(uiColor: .separator).opacity(0.01))
        #endif
    }
}
#endif
