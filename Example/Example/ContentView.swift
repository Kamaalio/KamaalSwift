//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalUI
import KamaalExtensions

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .kBold()
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!1111".digits)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
