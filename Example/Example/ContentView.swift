//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI
import KamaalUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .kBold()
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
