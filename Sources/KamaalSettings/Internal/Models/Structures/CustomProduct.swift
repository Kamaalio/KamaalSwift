//
//  CustomProduct.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import StoreKit
import Foundation

struct CustomProduct: Hashable, Identifiable {
    let id: String
    let emoji: Character
    let weight: Int
    let displayName: String
    let displayPrice: String
    let price: Decimal
    let description: String
    let product: Product?

    init(
        id: String,
        emoji: Character,
        weight: Int,
        displayName: String,
        displayPrice: String,
        price: Decimal,
        description: String,
        product: Product?,
    ) {
        self.id = id
        self.emoji = emoji
        self.weight = weight
        self.displayName = displayName
        self.displayPrice = displayPrice
        self.price = price
        self.description = description
        self.product = product
    }

    init(product: Product, emoji: Character, weight: Int) {
        self.init(
            id: product.id,
            emoji: emoji,
            weight: weight,
            displayName: product.displayName,
            displayPrice: product.displayPrice,
            price: product.price,
            description: product.description,
            product: product,
        )
    }

    var donation: StoreKitDonation {
        .init(id: self.id, emoji: self.emoji, weight: self.weight)
    }

    static let carrot = CustomProduct(
        id: "io.kamaal.KamaalSettings.Carrot",
        emoji: "🥕",
        weight: 1,
        displayName: "Carrot",
        displayPrice: "$420.69",
        price: 420.69,
        description: "Carrots are good for the eyes",
        product: .none,
    )
}
