//
//  ManagedObjectPropertyConfiguration.swift
//
//
//  Created by Kamaal M Farah on 16/11/2022.
//

import CoreData
import Foundation

/// Property configuration handled by ``ManuallyManagedObject``.
public class ManagedObjectPropertyConfiguration: ManagedObjectField {
    /// Property name.
    public let name: String
    /// Property type.
    public let type: PropertyTypes
    /// Wether or not the object is optional.
    public let isOptional: Bool

    /// Memberwise initializer.
    /// - Parameters:
    ///   - name: Property name.
    ///   - type: Property type.
    ///   - isOptional: Wether or not the object is optional.
    public init(name: String, type: PropertyTypes, isOptional: Bool) {
        self.name = name
        self.type = type
        self.isOptional = isOptional
    }

    /// Initialize with managed objects keypath.
    /// - Parameters:
    ///   - name: Property name.
    ///   - type: Property type.
    ///   - isOptional: Wether or not the object is optional.
    public convenience init(
        name: KeyPath<some ManuallyManagedObject, some Any>,
        type: PropertyTypes,
        isOptional: Bool,
    ) {
        self.init(name: NSExpression(forKeyPath: name).keyPath, type: type, isOptional: isOptional)
    }

    /// The managed objects property type represented in a enum.
    public enum PropertyTypes {
        /// `Date` type.
        case date
        /// `UUID` type.
        case uuid
        /// `URL` type.
        case url
        /// `Data` type.
        case data
        /// `Bool` type.
        case bool
        /// `String` type.
        case string
        /// `Float` type.
        case float
        /// `Doublie` type.
        case double
        /// `Int64` type.
        case int64
        /// `Int32` type.
        case int32
        /// `Int16` type.
        case int16

        fileprivate var nsAttributeType: NSAttributeType {
            switch self {
            case .date:
                .dateAttributeType
            case .uuid:
                .UUIDAttributeType
            case .url:
                .URIAttributeType
            case .data:
                .binaryDataAttributeType
            case .bool:
                .booleanAttributeType
            case .string:
                .stringAttributeType
            case .float:
                .floatAttributeType
            case .double:
                .doubleAttributeType
            case .int64:
                .integer64AttributeType
            case .int32:
                .integer32AttributeType
            case .int16:
                .integer16AttributeType
            }
        }
    }

    override public var property: NSPropertyDescription? {
        get {
            let attribute = NSAttributeDescription()
            attribute.name = self.name
            attribute.attributeType = self.type.nsAttributeType
            attribute.isOptional = self.isOptional
            return attribute
        }
        set { }
    }
}
