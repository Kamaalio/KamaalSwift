//
//  StoreTests.swift
//
//
//  Created by Kamaal M Farah on 25/12/2022.
//

import XCTest
@testable import KamaalSettings

final class StoreTests: XCTestCase {
    var store: Store!

    override func setUpWithError() throws {
        store = Store(donations: donations, productFetcher: MockProductFetcher())
    }

    func testGetAllProducts() async throws {
        try await store.requestProducts().get()
        XCTAssertEqual(store.donations.count, donations.count)
    }
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
