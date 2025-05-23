//
//  Item.swift
//  Example
//
//  Created by Kamaal M Farah on 27/04/2023.
//

import CoreData
import KamaalCoreData

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
            relationshipType: .toMany
        ),
    ]
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
            relationshipType: .toOne
        ),
    ]
}
