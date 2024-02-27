//
//  Navigator.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI

public final class Navigator<StackValue: NavigatorStackValue>: ObservableObject {
    @Published private var stacks: [StackValue: [StackValue]]

    @Published var currentStack: StackValue

    init(stack: [StackValue], initialStack: StackValue = .root) {
        self.stacks = [initialStack: stack]
        self.currentStack = initialStack
    }

    var currentScreen: StackValue? {
        self.stacks[self.currentStack]?.last
    }

    var screens: [StackValue] {
        Array(StackValue.allCases)
    }

    /// Changes stacks.
    /// - Parameter stack: the stack to change to
    @MainActor
    public func changeStack(to stack: StackValue) {
        guard self.currentStack != stack else { return }

        if self.stacks[stack] == nil {
            self.stacks[stack] = []
        }
        self.currentStack = stack
    }

    /// Navigates to the given destination.
    ///
    /// - Parameter destination: Where to navigate to.
    @MainActor
    public func navigate(to destination: StackValue) {
        withAnimation { self.stacks[self.currentStack]?.append(destination) }
    }

    /// Navigates back.
    @MainActor
    public func goBack() {
        withAnimation { _ = self.stacks[self.currentStack]?.popLast() }
    }

    func getBindingPath(forStack stack: StackValue) -> Binding<[StackValue]> {
        Binding(
            get: { [weak self] in
                guard let self else { return [] }
                return self.stacks[stack] ?? []
            },
            set: { [weak self] newValue in
                guard let self else { return }
                self.stacks[stack] = newValue
            }
        )
    }

    func getBindingPath() -> Binding<[StackValue]> {
        self.getBindingPath(forStack: self.currentStack)
    }
}
