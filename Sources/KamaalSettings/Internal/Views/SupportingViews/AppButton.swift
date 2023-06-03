//
//  AppButton.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalUI

struct AppButton<Content: View>: View {
    let action: () -> Void
    let content: Content

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            content
                .foregroundColor(.accentColor)
                .kInvisibleFill()
        }
        .buttonStyle(.plain)
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(action: { }) {
            Text("Content")
        }
    }
}
