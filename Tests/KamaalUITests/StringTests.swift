//
//  StringTests.swift
//
//
//  Created by Kamaal M Farah on 30/12/2022.
//

import XCTest
@testable import KamaalUI

final class StringTests: XCTestCase {
    func testSanitizesStringToDouble() {
        let cases = [
            ("0.001234", 0.001234),
            ("", 0),
            (".", 0),
            (".12", 0.12),
            (".12.22", 0.12),
            ("12.12.22", 12.12),
            ("12..22", 12),
            ("12.G", 12),
        ]
        for (input, expected) in cases {
            XCTAssertEqual(input.sanitizedDouble, expected)
        }
    }
}
