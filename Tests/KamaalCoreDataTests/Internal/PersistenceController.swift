//
//  PersistenceController.swift
//
//
//  Created by Kamaal M Farah on 14/11/2022.
//

@preconcurrency import CoreData
import KamaalCoreData

struct PersistenceController {
    let container: NSPersistentContainer

    init() {
        let persistentContainerBuilder = _PersistentContainerBuilder(
            entities: PersistenceController.entities,
            containerName: "KamaalCoreDataTests",
            preview: true,
        )
        self.container = persistentContainerBuilder.make()
        self.container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static let entities: [NSEntityDescription] = [
        Item.entity,
    ]

    static let shared = PersistenceController()
}

@objc(Item)
class Item: NSManagedObject, ManuallyManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var timestamp: Date
    @NSManaged var children: NSSet?

    var childrenArray: [Child] {
        self.children?.allObjects as? [Child] ?? []
    }

    func addChild(_ child: Child, save: Bool) throws {
        self.children = NSSet(array: self.childrenArray + [child])

        if save {
            try managedObjectContext?.save()
        }
    }

    func addChild(_ child: Child) throws {
        try self.addChild(child, save: true)
    }

    nonisolated(unsafe) static let properties: [ManagedObjectPropertyConfiguration] = [
        ManagedObjectPropertyConfiguration(name: \Item.id, type: .uuid, isOptional: false),
        ManagedObjectPropertyConfiguration(name: \Item.timestamp, type: .date, isOptional: false),
    ]

    nonisolated(unsafe) static let _relationships: [_RelationshipConfiguration] = [
        _RelationshipConfiguration(
            name: "children",
            destinationEntity: Child.self,
            inverseRelationshipName: "parent",
            inverseRelationshipEntity: Item.self,
            isOptional: true,
            relationshipType: .toMany,
        ),
    ]

    static func create(context: NSManagedObjectContext, save: Bool = true) throws -> Item {
        let item = Item(context: context)
        item.timestamp = Date()
        item.id = UUID()

        if save {
            try context.save()
        }

        return item
    }
}

@objc(Child)
class Child: NSManagedObject, ManuallyManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var timestamp: Date
    @NSManaged var parent: Item

    nonisolated(unsafe) static let properties: [ManagedObjectPropertyConfiguration] = [
        ManagedObjectPropertyConfiguration(name: \Child.id, type: .uuid, isOptional: false),
        ManagedObjectPropertyConfiguration(name: \Child.timestamp, type: .date, isOptional: false),
    ]

    nonisolated(unsafe) static let _relationships: [_RelationshipConfiguration] = [
        _RelationshipConfiguration(
            name: "parent",
            destinationEntity: Item.self,
            inverseRelationshipName: "children",
            inverseRelationshipEntity: Child.self,
            isOptional: false,
            relationshipType: .toOne,
        ),
    ]
}
