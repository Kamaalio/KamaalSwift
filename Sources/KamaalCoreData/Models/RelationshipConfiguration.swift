//
//  RelationshipConfiguration.swift
//
//
//  Created by Kamaal M Farah on 16/11/2022.
//

import CoreData
import Foundation

// swiftlint:disable type_name
public class _RelationshipConfiguration: ManagedObjectField {
    public let name: String
    public let destinationEntityName: String
    public let inverseRelationshipName: String
    public let inverseRelationshipEntityName: String
    public let isOptional: Bool
    public let relationshipType: RelationshipType
    private(set) var destinationEntity: NSEntityDescription?

    public init(
        name: String,
        destinationEntity: String,
        inverseRelationshipName: String,
        inverseRelationshipEntityName: String,
        isOptional: Bool,
        relationshipType: RelationshipType
    ) {
        self.name = name
        self.destinationEntityName = destinationEntity
        self.inverseRelationshipName = inverseRelationshipName
        self.inverseRelationshipEntityName = inverseRelationshipEntityName
        self.isOptional = isOptional
        self.relationshipType = relationshipType
    }

    public convenience init(
        name: String,
        destinationEntity: (some ManuallyManagedObject).Type,
        inverseRelationshipName: String,
        inverseRelationshipEntity: (some ManuallyManagedObject).Type,
        isOptional: Bool,
        relationshipType: RelationshipType
    ) {
        self.init(
            name: name,
            destinationEntity: destinationEntity.entityName,
            inverseRelationshipName: inverseRelationshipName,
            inverseRelationshipEntityName: inverseRelationshipEntity.entityName,
            isOptional: isOptional,
            relationshipType: relationshipType
        )
    }

    override public var property: NSPropertyDescription? {
        get {
            let relationship = NSRelationshipDescription()
            relationship.name = self.name
            relationship.isOptional = self.isOptional
            relationship.destinationEntity = self.destinationEntity

            switch self.relationshipType {
            case .toMany:
                relationship.maxCount = 0
            case .toOne:
                relationship.maxCount = 1
            }

            return relationship
        }
        set { }
    }

    func setDestinationEntity(_ destinationEntity: NSEntityDescription) -> _RelationshipConfiguration {
        let configuration = _RelationshipConfiguration(
            name: name,
            destinationEntity: destinationEntityName,
            inverseRelationshipName: inverseRelationshipName,
            inverseRelationshipEntityName: inverseRelationshipEntityName,
            isOptional: isOptional,
            relationshipType: relationshipType
        )
        configuration.destinationEntity = destinationEntity
        return configuration
    }
}

public enum RelationshipType {
    case toMany
    case toOne
}
