//
//  KamaalCoreDataTests.swift
//
//
//  Created by Kamaal M Farah on 23/04/2023.
//

import XCTest
import KamaalExtensions
@testable import KamaalCoreData

final class KamaalCoreDataTests: XCTestCase {
    let viewContext = PersistenceController.shared.container.viewContext

    override func tearDownWithError() throws {
        try Item.clear(in: viewContext)
    }

    func testItemGetsCreated() throws {
        _ = try Item.create(context: viewContext, save: true)

        let items = try Item.list(from: viewContext)
        XCTAssertEqual(items.count, 1)
    }

    func testItemIsDeleted() throws {
        let item = try Item.create(context: viewContext, save: true)

        try item.delete()
        let items = try Item.list(from: viewContext)
        XCTAssert(items.isEmpty)
    }

    func testCorrectItemsGetFiltered() throws {
        let items = try createItems(amount: 3)

        let itemsToSearchFor = [items[0], items[2]]
        let predicate = NSPredicate(format: "id IN %@", itemsToSearchFor.map(\.id.nsString))
        let limit = 3
        let filteredItems = try Item.filter(by: predicate, limit: limit, from: viewContext)

        XCTAssertEqual(filteredItems.count, itemsToSearchFor.count)
        XCTAssertNotEqual(filteredItems.count, limit)
        XCTAssert(filteredItems.allSatisfy { itemsToSearchFor.contains($0) })
    }

    func testFoundItem() throws {
        let items = try createItems(amount: 3)

        let predicate = NSPredicate(format: "id = %@", items[1].id.nsString)
        let foundItem = try Item.find(by: predicate, from: viewContext)

        XCTAssertEqual(foundItem, items[1])
    }

    func testItemNotFound() throws {
        _ = try createItems(amount: 3)

        let predicate = NSPredicate(format: "id = %@", UUID().nsString)
        let foundItem = try Item.find(by: predicate, from: viewContext)

        XCTAssertNil(foundItem)
    }

    func testBatchDelete() throws {
        let items = try createItems(amount: 3)

        let itemsToDeleteIDs = [items[0], items[2]].map(\.id.nsString)
        let predicate = NSPredicate(format: "id IN %@", itemsToDeleteIDs)
        try Item.batchDelete(by: predicate, in: viewContext)

        for id in itemsToDeleteIDs {
            let predicate = NSPredicate(format: "id = %@", id)
            let itemThatShouldNotBeFound = try Item.find(by: predicate, from: viewContext)
            XCTAssertNil(itemThatShouldNotBeFound)
        }

        let predicateForItemThatIsNotDeleted = NSPredicate(format: "id = %@", items[1].id.nsString)
        let foundItem = try Item.find(by: predicateForItemThatIsNotDeleted, from: viewContext)

        XCTAssertEqual(foundItem, items[1])
    }

    func createItems(amount: Int) throws -> [Item] {
        var items: [Item] = []
        for i in 0 ..< amount {
            let item = try Item.create(context: viewContext, save: i == (amount - 1))
            items = items.appended(item)
        }
        return items
    }
}
