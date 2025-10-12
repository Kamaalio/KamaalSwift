//
//  KeychainTests.swift
//  KamaalSwift
//
//  Created by Kamaal M Farah on 10/12/25.
//

import Testing
import Foundation
import KamaalUtils

// MARK: - Basic Keychain Operations

@Test("Set and get data from keychain")
func setAndGetData() throws {
    let key = "test_key_\(UUID().uuidString)"
    let testData = "Hello, Keychain!".data(using: .utf8)!

    // Clean up any existing data
    _ = Keychain.delete(forKey: key)

    // Set data
    let setResult = Keychain.set(testData, forKey: key)
    #expect(setResult.isSuccess)

    // Get data
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == testData)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

@Test("Get non-existent key returns nil")
func getNonExistentKey() throws {
    let key = "non_existent_key_\(UUID().uuidString)"

    // Ensure key doesn't exist
    _ = Keychain.delete(forKey: key)

    let result = try Keychain.get(forKey: key).get()
    #expect(result == nil)
}

@Test("Delete existing key")
func deleteExistingKey() throws {
    let key = "delete_test_key_\(UUID().uuidString)"
    let testData = "Data to delete".data(using: .utf8)!

    // Set data
    _ = Keychain.set(testData, forKey: key)

    // Delete data
    let deleteResult = Keychain.delete(forKey: key)
    #expect(deleteResult.isSuccess)

    // Verify deletion
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == nil)
}

@Test("Delete non-existent key fails")
func deleteNonExistentKey() {
    let key = "non_existent_delete_key_\(UUID().uuidString)"

    // Ensure key doesn't exist
    _ = Keychain.delete(forKey: key)

    // Try to delete again
    let result = Keychain.delete(forKey: key)
    #expect(result.isFailure)
}

// MARK: - Update Operations

@Test("Update existing key with new data")
func updateExistingKey() throws {
    let key = "update_test_key_\(UUID().uuidString)"
    let initialData = "Initial Data".data(using: .utf8)!
    let updatedData = "Updated Data".data(using: .utf8)!

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set initial data
    _ = Keychain.set(initialData, forKey: key)

    // Update with new data
    let updateResult = Keychain.set(updatedData, forKey: key)
    #expect(updateResult.isSuccess)

    // Verify update
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == updatedData)
    #expect(getResult != initialData)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

@Test("Multiple updates to same key")
func multipleUpdates() throws {
    let key = "multiple_updates_key_\(UUID().uuidString)"

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set and update multiple times
    for i in 1 ... 5 {
        let data = "Data version \(i)".data(using: .utf8)!
        let setResult = Keychain.set(data, forKey: key)
        #expect(setResult.isSuccess)

        let getResult = try Keychain.get(forKey: key).get()
        #expect(getResult == data)
    }

    // Clean up
    _ = Keychain.delete(forKey: key)
}

// MARK: - Data Types

@Test("Store and retrieve empty data")
func storeEmptyData() throws {
    let key = "empty_data_key_\(UUID().uuidString)"
    let emptyData = Data()

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set empty data
    let setResult = Keychain.set(emptyData, forKey: key)
    #expect(setResult.isSuccess)

    // Get empty data
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == emptyData)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

@Test("Store and retrieve large data")
func storeLargeData() throws {
    let key = "large_data_key_\(UUID().uuidString)"
    // Create 1MB of data
    let largeData = Data(repeating: 42, count: 1_000_000)

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set large data
    let setResult = Keychain.set(largeData, forKey: key)
    #expect(setResult.isSuccess)

    // Get large data
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == largeData)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

@Test("Store and retrieve JSON data")
func storeJSONData() throws {
    struct TestModel: Codable, Equatable {
        let name: String
        let age: Int
        let active: Bool
    }

    let key = "json_data_key_\(UUID().uuidString)"
    let model = TestModel(name: "Test User", age: 25, active: true)
    let jsonData = try JSONEncoder().encode(model)

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set JSON data
    let setResult = Keychain.set(jsonData, forKey: key)
    #expect(setResult.isSuccess)

    // Get and decode JSON data
    let getResult = try Keychain.get(forKey: key).get()
    let decodedModel = try JSONDecoder().decode(TestModel.self, from: getResult!)
    #expect(decodedModel == model)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

// MARK: - Multiple Keys

@Test("Store multiple keys independently")
func storeMultipleKeys() throws {
    let keys = (1 ... 5).map { "multi_key_\(UUID().uuidString)_\($0)" }

    // Clean up
    keys.forEach { _ = Keychain.delete(forKey: $0) }

    // Set data for each key
    for (index, key) in keys.enumerated() {
        let data = "Data for key \(index)".data(using: .utf8)!
        let setResult = Keychain.set(data, forKey: key)
        #expect(setResult.isSuccess)
    }

    // Verify each key has correct data
    for (index, key) in keys.enumerated() {
        let expectedData = "Data for key \(index)".data(using: .utf8)!
        let getResult = try Keychain.get(forKey: key).get()
        #expect(getResult == expectedData)
    }

    // Clean up
    keys.forEach { _ = Keychain.delete(forKey: $0) }
}

@Test("Delete one key doesn't affect others")
func deleteOneKeyDoesNotAffectOthers() throws {
    let key1 = "independent_key_1_\(UUID().uuidString)"
    let key2 = "independent_key_2_\(UUID().uuidString)"
    let data1 = "Data 1".data(using: .utf8)!
    let data2 = "Data 2".data(using: .utf8)!

    // Clean up
    _ = Keychain.delete(forKey: key1)
    _ = Keychain.delete(forKey: key2)

    // Set both keys
    _ = Keychain.set(data1, forKey: key1)
    _ = Keychain.set(data2, forKey: key2)

    // Delete first key
    let deleteResult = Keychain.delete(forKey: key1)
    #expect(deleteResult.isSuccess)

    // Verify first key is deleted
    let getResult1 = try Keychain.get(forKey: key1).get()
    #expect(getResult1 == nil)

    // Verify second key still exists
    let getResult2 = try Keychain.get(forKey: key2).get()
    #expect(getResult2 == data2)

    // Clean up
    _ = Keychain.delete(forKey: key2)
}

// MARK: - Edge Cases

@Test("Handle special characters in key")
func handleSpecialCharactersInKey() throws {
    let key = "special_key_!@#$%^&*()_+-=[]{}|;:',.<>?/~`_\(UUID().uuidString)"
    let testData = "Special key data".data(using: .utf8)!

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set data
    let setResult = Keychain.set(testData, forKey: key)
    #expect(setResult.isSuccess)

    // Get data
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == testData)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

@Test("Handle unicode in data")
func handleUnicodeInData() throws {
    let key = "unicode_key_\(UUID().uuidString)"
    let unicodeString = "Hello 世界 🌍 مرحبا Привет"
    let testData = unicodeString.data(using: .utf8)!

    // Clean up
    _ = Keychain.delete(forKey: key)

    // Set data
    let setResult = Keychain.set(testData, forKey: key)
    #expect(setResult.isSuccess)

    // Get data
    let getResult = try Keychain.get(forKey: key).get()
    #expect(getResult == testData)

    // Verify string conversion
    let retrievedString = String(data: getResult!, encoding: .utf8)
    #expect(retrievedString == unicodeString)

    // Clean up
    _ = Keychain.delete(forKey: key)
}

// MARK: - Helper Extensions

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: true
        case .failure: false
        }
    }

    var isFailure: Bool {
        !self.isSuccess
    }
}
