//
//  StoreKitDonation.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation
import KamaalExtensions

public struct StoreKitDonation: Hashable, Identifiable, Codable {
    public let id: String
    public let emoji: String
    public let weight: Int

    public init(id: String, emoji: Character, weight: Int) {
        self.id = id
        self.emoji = emoji.string
        self.weight = weight
    }

    var emojiCharacter: Character {
        emoji.first!
    }
}
