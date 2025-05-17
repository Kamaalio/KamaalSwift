//
//  KamaalNavigationTests.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import XCTest
@testable import KamaalNavigation

final class KamaalNavigationTests: XCTestCase {
    func testInitializer() {
        let stack = Navigator<PreviewScreenType>(stack: [.screen, .sub])
        XCTAssertEqual(stack.currentScreen, .sub)
    }

    func testEmptyStackInitializer() {
        let stack = Navigator(stack: [] as [PreviewScreenType])
        XCTAssertNil(stack.currentScreen)
    }

    #if os(macOS)
    @MainActor
    func testNavigate() async {
        let stack = Navigator<PreviewScreenType>(stack: [.sub, .screen])
        stack.navigate(to: .screen)
        XCTAssertEqual(stack.currentScreen, .screen)
        stack.navigate(to: .sub)
        XCTAssertEqual(stack.currentScreen, .sub)
    }

    @MainActor
    func testGoBack() async {
        let stack = Navigator<PreviewScreenType>(stack: [.screen, .sub])
        stack.goBack()
        XCTAssertEqual(stack.currentScreen, .screen)
        stack.goBack()
        XCTAssertNil(stack.currentScreen)
        stack.goBack()
        XCTAssertNil(stack.currentScreen)
        stack.navigate(to: .sub)
        XCTAssertEqual(stack.currentScreen, .sub)
    }
    #endif
}
