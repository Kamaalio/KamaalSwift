//
//  UserDefaultsTests.swift
//
//
//  Created by Kamaal M Farah on 30/05/2023.
//

import XCTest
import KamaalUtils

final class UserDefaultsTests: XCTestCase {
    @UserDefaultsValue(key: "test_value")
    static var testValue: String?

    @UserDefaultsObject(key: "test_object")
    static var testObject: TestObject?

    override class func setUp() {
        Self._testValue.removeValue()
        Self._testObject.removeValue()
    }

    func testUserdefaultsValue() {
        let valueToSet = "Kamaal"
        Self.testValue = valueToSet

        XCTAssertEqual(Self.testValue, valueToSet)

        Self._testValue.removeValue()

        XCTAssertNil(Self.testValue)
    }

    func testUserdefaultsValueSettingNil() {
        let valueToSet = "Niller"
        Self.testValue = valueToSet

        XCTAssertEqual(Self.testValue, valueToSet)

        Self.testValue = nil

        XCTAssertNil(Self.testValue)
    }

    func testUserDefaultsObject() {
        let objectToSet = TestObject(value: "Test")
        Self.testObject = objectToSet

        XCTAssertEqual(Self.testObject, objectToSet)

        Self._testObject.removeValue()

        XCTAssertNil(Self.testObject)
    }

    func testUserDefaultsObjectSettingNil() {
        let objectToSet = TestObject(value: "Something")
        Self.testObject = objectToSet

        XCTAssertEqual(Self.testObject, objectToSet)

        Self.testObject = nil

        XCTAssertNil(Self.testObject)
    }
}
