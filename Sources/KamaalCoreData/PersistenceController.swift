//
//  PersistenceController.swift
//
//
//  Created by Kamaal M Farah on 06/05/2023.
//

import CoreData
import Foundation
import KamaalExtensions

public class PersistenceController {
    private let container: NSPersistentContainer

    public init(
        containerName: String,
        entities: [NSEntityDescription],
        relationships: [_RelationshipConfiguration] = [],
        inMemory: Bool = false,
    ) {
        let persistentContainerBuilder = _PersistentContainerBuilder(
            entities: entities,
            relationships: relationships,
            containerName: containerName,
            preview: inMemory,
        )
        self.container = persistentContainerBuilder.make()

        if !inMemory, let defaultURL = container.persistentStoreDescriptions.first?.url {
            let defaultStore = NSPersistentStoreDescription(url: defaultURL)
            defaultStore.configuration = "Default"
            defaultStore.shouldMigrateStoreAutomatically = false
            defaultStore.shouldInferMappingModelAutomatically = true
        }

        self.container.viewContext.automaticallyMergesChangesFromParent = true

        self.container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    public var context: NSManagedObjectContext {
        self.container.viewContext
    }
}
