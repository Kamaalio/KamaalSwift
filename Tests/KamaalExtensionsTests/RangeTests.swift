//
//  RangeTests.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import Testing
import KamaalExtensions

@Test("Transforms range to array")
func transformsRangeToArray() {
    let range = 0 ..< 3

    #expect(range.asArray() == [0, 1, 2])
}

@Test("Transforms closed range to array")
func transformsClosedRangeToArray() {
    let range = 0 ... 3

    #expect(range.asArray() == [0, 1, 2, 3])
}
