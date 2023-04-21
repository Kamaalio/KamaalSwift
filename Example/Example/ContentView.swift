//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalUI
import KamaalLogger
import KamaalExtensions

private let logger = KamaalLogger(from: ContentView.self)

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: { logger.info("Logged stuff") }) {
                Image(systemName: "globe")
                    .kBold()
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!1111".digits)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
