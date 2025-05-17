//
//  StoreTests.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import Testing
@testable import KamaalSettings

@Test
func getAllProducts() async throws {
    var store = await setup()

    try await store.requestProducts().get()

    await #expect(store.donations.count == donations.count)
}

@MainActor
private func setup() -> Store {
    Store(donations: donations, productFetcher: MockProductFetcher())
}

struct MockProductFetcher: ProductFetcher {
    func getProducts(by _: [StoreKitDonation.ID: StoreKitDonation]) async throws -> [CustomProduct] {
        donations
            .map { donation in
                CustomProduct(
                    id: donation.id,
                    emoji: donation.emojiCharacter,
                    weight: donation.weight,
                    displayName: String(donation.id.split(separator: ".").last!),
                    displayPrice: "420",
                    price: 420.0,
                    description: "Description",
                    product: .none
                )
            }
    }
}

private let donations: [StoreKitDonation] = [
    .init(id: "io.kamaal.Example.Carrot", emoji: "🥕", weight: 1),
    .init(id: "io.kamaal.Example.House", emoji: "🏡", weight: 20),
    .init(id: "io.kamaal.Example.Ship", emoji: "🚢", weight: 69),
]
