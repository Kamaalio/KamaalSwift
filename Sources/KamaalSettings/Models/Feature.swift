//
//  Feature.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import Foundation

public struct Feature: Hashable, Identifiable, Sendable {
    public let id: UUID
    public let label: String
    public let isEnabled: Bool

    public init(id: UUID, label: String, isEnabled: Bool) {
        self.id = id
        self.label = label
        self.isEnabled = isEnabled
    }
}
