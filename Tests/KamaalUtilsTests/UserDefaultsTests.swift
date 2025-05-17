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
    var testValue: String?

    @UserDefaultsObject(key: "test_object")
    var testObject: TestObject?

    override func setUp() {
        self._testValue.removeValue()
        self._testObject.removeValue()
    }

    func testUserdefaultsValue() {
        let valueToSet = "Kamaal"
        self.testValue = valueToSet

        XCTAssertEqual(self.testValue, valueToSet)

        self._testValue.removeValue()

        XCTAssertNil(self.testValue)
    }

    func testUserdefaultsValueSettingNil() {
        let valueToSet = "Niller"
        self.testValue = valueToSet

        XCTAssertEqual(self.testValue, valueToSet)

        self.testValue = nil

        XCTAssertNil(self.testValue)
    }

    func testUserDefaultsObject() {
        let objectToSet = TestObject(value: "Test")
        self.testObject = objectToSet

        XCTAssertEqual(self.testObject, objectToSet)

        self._testObject.removeValue()

        XCTAssertNil(self.testObject)
    }

    func testUserDefaultsObjectSettingNil() {
        let objectToSet = TestObject(value: "Something")
        self.testObject = objectToSet

        XCTAssertEqual(self.testObject, objectToSet)

        self.testObject = nil

        XCTAssertNil(self.testObject)
    }
}
