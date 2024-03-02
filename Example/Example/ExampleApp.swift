//
//  ExampleApp.swift
//  Example
//
//  Created by Kamaal M Farah on 21/04/2023.
//

import SwiftUI

@main
struct ExampleApp: App {
    @StateObject private var userSettings = UserSettings()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 300, minHeight: 300)
                .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
                .environmentObject(self.userSettings)
        }
    }
}
