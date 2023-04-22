//
//  AppColor.swift
//
//
//  Created by Kamaal M Farah on 22/12/2022.
//

import SwiftUI

public struct AppColor: Hashable, Identifiable {
    public let id: UUID
    public let name: String
    public let color: Color

    public init(id: UUID, name: String, color: Color) {
        self.id = id
        self.color = color
        self.name = name
    }
}
