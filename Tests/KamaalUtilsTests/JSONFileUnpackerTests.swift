//
//  JSONFileUnpackerTests.swift
//
//
//  Created by Kamaal M Farah on 30/05/2023.
//

import XCTest
import Foundation
import KamaalUtils

final class JSONFileUnpackerTests: XCTestCase {
    func testGetFileContent() throws {
        let content = try JSONFileUnpacker<TestObject>(filename: "test", bundle: .module).content

        XCTAssertEqual(content.value, "🐸FROG KINGDOM🐸")
    }

    func testFileNotFound() {
        XCTAssertThrowsError(try JSONFileUnpacker<TestObject>(filename: "testy", bundle: .module)) { error in
            let error = error as! JSONFileUnpackerErrors

            XCTAssertEqual(error, .fileNotFound)
        }
    }

    func testDecodingFailure() {
        XCTAssertThrowsError(try JSONFileUnpacker<String>(filename: "test", bundle: .module)) { error in
            let error = error as! JSONFileUnpackerErrors

            let decodingError = DecodingError.typeMismatch(
                String.self,
                DecodingError
                    .Context(
                        codingPath: [],
                        debugDescription: "Expected to decode String but found a dictionary instead.",
                        underlyingError: nil,
                    ),
            )
            XCTAssertEqual(error, .decodingFailure(context: decodingError))
        }
    }
}
