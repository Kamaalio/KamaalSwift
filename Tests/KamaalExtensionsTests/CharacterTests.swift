//
//  CharacterTests.swift
//
//
//  Created by Kamaal M Farah on 17/12/2022.
//

import Quick
import Nimble
import Foundation
import KamaalExtensions

final class CharacterTests: QuickSpec {
    override func spec() {
        describe("int") {
            context("transforming characters to integers") {
                let cases: [(Character, Int)] = [
                    ("1", 1),
                ]
                for (character, expectedInt) in cases {
                    it("transforms \(character) to \(expectedInt)") {
                        expect(character.int) == expectedInt
                    }
                }
            }

            context("failing to transform character to integer") {
                let cases: [Character] = [
                    "K",
                    "O",
                ]
                for character in cases {
                    it("failed transforms \(character) to integer") {
                        expect(character.int).to(beNil())
                    }
                }
            }
        }
    }
}
