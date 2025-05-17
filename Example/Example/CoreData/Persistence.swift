//
//  Persistence.swift
//  Example
//
//  Created by Kamaal M Farah on 23/04/2023.
//

import CoreData
import Dispatch
import KamaalCoreData

struct PersistenceController {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let persistentContainerBuilder = _PersistentContainerBuilder(
            entities: [Item.entity, Child.entity],
            relationships: Item._relationships + Child._relationships,
            containerName: "Example",
            preview: inMemory
        )
        self.container = persistentContainerBuilder.make()
        self.container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static let shared = PersistenceController()

    #if DEBUG
    nonisolated(unsafe) static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0 ..< 10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    #endif
}
