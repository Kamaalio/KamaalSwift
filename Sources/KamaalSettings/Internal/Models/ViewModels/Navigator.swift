//
//  Navigator.swift
//
//
//  Created by Kamaal M Farah on 24/12/2022.
//

import SwiftUI
import KamaalStructures

final class Navigator: ObservableObject {
    @Published private var stack = Stack<ScreenSelection>()

    init() { }

    var currentScreen: ScreenSelection? {
        stack.peek()
    }

    @MainActor
    func navigate(to destination: ScreenSelection) {
        withAnimation(.easeOut(duration: 0.3)) {
            stack.push(destination)
        }
    }

    @MainActor
    func goBack() {
        withAnimation(.easeOut(duration: 0.3)) {
            _ = stack.pop()
        }
    }
}
