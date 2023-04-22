//
//  SwiftUIView.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import SwiftUI

struct MainView: View {
    let screen: ScreenSelection

    var body: some View {
        switch screen {
        case .acknowledgements:
            AcknowledgementsScreen()
        case .appColor:
            AppColorScreen()
        case .appIcon:
            AppIconScreen()
        case let .feedback(style, description):
            FeedbackScreen(style: style, description: description)
        case .logs:
            LogsScreen()
        case .supportAuthor:
            SupportAuthorScreen()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(screen: .logs)
    }
}
