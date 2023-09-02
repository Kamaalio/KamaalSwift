//
//  ExampleApp.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI

@main
struct ExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
