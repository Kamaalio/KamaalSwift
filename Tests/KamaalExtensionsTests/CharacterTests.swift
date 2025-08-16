//
//  CharacterTests.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import Testing
import Foundation
import KamaalExtensions

@Test("Transforming characters to integers", arguments: [
    ("1", 1),
])
func transformingCharactersToIntegers(character: Character, expectedInt: Int) {
    #expect(character.int == expectedInt)
}

@Test("Failing to transform character to integer", arguments: [
    "K",
    "O",
])
func failingToTransformCharacterToInteger(character: Character) {
    #expect(character.int == nil)
}
