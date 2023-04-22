//
//  AppIcon.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI

public struct AppIcon: Hashable, Identifiable, Codable {
    public let id: UUID
    public let imageName: String
    public let title: String

    public init(id: UUID, imageName: String, title: String) {
        self.id = id
        self.imageName = imageName
        self.title = title
    }
}
