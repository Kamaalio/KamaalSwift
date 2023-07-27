//
//  ShellTests.swift
//
//
//  Created by Kamaal M Farah on 27/07/2023.
//

#if os(macOS)
import XCTest
import Foundation
import KamaalUtils
import KamaalExtensions

final class ShellTests: XCTestCase {
    func testEchosHello() throws {
        let result = try Shell.zsh("echo hello").get().splitLines.last
        XCTAssertEqual(result, "hello")
    }

    func testFailsOnCommandNotFound() throws {
        let command = "ggggggggggg"
        XCTAssertThrowsError(try Shell.zsh(command).get()) { error in
            let error = error as? Shell.Errors
            XCTAssertEqual(error, .standardError(message: "zsh:1: command not found: \(command)\n"))
        }
    }
}
#endif
