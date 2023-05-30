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
    func testNavigate() async {
        let stack = Navigator<PreviewScreenType>(stack: [.sub, .screen])
        await stack.navigate(to: .screen)
        XCTAssertEqual(stack.currentScreen, .screen)
        await stack.navigate(to: .sub)
        XCTAssertEqual(stack.currentScreen, .sub)
    }

    func testGoBack() async {
        let stack = Navigator<PreviewScreenType>(stack: [.screen, .sub])
        await stack.goBack()
        XCTAssertEqual(stack.currentScreen, .screen)
        await stack.goBack()
        XCTAssertNil(stack.currentScreen)
        await stack.goBack()
        XCTAssertNil(stack.currentScreen)
        await stack.navigate(to: .sub)
        XCTAssertEqual(stack.currentScreen, .sub)
    }
    #endif
}
