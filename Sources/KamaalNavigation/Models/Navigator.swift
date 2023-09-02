//
//  Navigator.swift
//
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import KamaalStructures

public final class Navigator<StackValue: NavigatorStackValue>: ObservableObject {
    @Published private var stacks: [StackValue: Stack<StackValue>] {
        didSet { self.stacksDidSet() }
    }

    @Published var currentStack: StackValue

    private let notifications: [Notification.Name] = [
        .navigate,
    ]

    init(stack: [StackValue], initialStack: StackValue = .root) {
        let stack = Stack.fromArray(stack)
        self.stacks = [initialStack: stack]
        self.currentStack = initialStack
        self.setupNotifications()
    }

    deinit {
        removeNotifications()
    }

    public enum NavigatorNotifications {
        case navigate(destination: StackValue)

        var name: Notification.Name {
            switch self {
            case .navigate:
                return .navigate
            }
        }
    }

    var currentScreen: StackValue? {
        self.stacks[self.currentStack]?.peek()
    }

    var screens: [StackValue] {
        Array(StackValue.allCases)
    }

    @MainActor
    func changeStack(to stack: StackValue) {
        guard self.currentStack != stack else { return }

        if self.stacks[stack] == nil {
            self.stacks[stack] = Stack()
        }
        self.currentStack = stack
    }

    /// Navigates to the given destination.
    ///
    /// WARNING: This method only works on macOS.
    /// - Parameter destination: Where to navigate to.
    @MainActor
    public func navigate(to destination: StackValue) {
        #if !os(macOS)
        assertionFailure("This method is only supported on macOS")
        #else
        withAnimation { self.stacks[self.currentStack]?.push(destination) }
        #endif
    }

    /// Navigates back.
    ///
    /// WARNING: This method only works on macOS.
    @MainActor
    public func goBack() {
        #if !os(macOS)
        assertionFailure("This method is only supported on macOS")
        #else
        withAnimation { _ = self.stacks[self.currentStack]?.pop() }
        #endif
    }

    public static func notify(_ event: NavigatorNotifications) {
        NotificationCenter.default.post(name: event.name, object: event)
    }

    private func setupNotifications() {
        for notification in self.notifications {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.handleNotification),
                name: notification,
                object: nil
            )
        }
    }

    private func removeNotifications() {
        for notification in self.notifications {
            NotificationCenter.default.removeObserver(self, name: notification, object: nil)
        }
    }

    @objc
    private func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .navigate:
            guard let event = notification.object as? NavigatorNotifications,
                  case let .navigate(destination: destination) = event else {
                assertionFailure("Incorrect event sent")
                return
            }

            Task { await self.navigate(to: destination) }
        default:
            assertionFailure("Unhandled notification")
        }
    }

    private func stacksDidSet() {
        NotificationCenter.default.post(name: .hasChangedScreens, object: self.currentScreen)
    }
}

extension Notification.Name {
    public static let navigate = makeNotificationName(withKey: "navigate")
    public static let hasChangedScreens = makeNotificationName(withKey: "has_changed_screens")

    private static func makeNotificationName(withKey key: String) -> Notification.Name {
        Notification.Name("io.kamaal.BetterNavigation.notifications.\(key)")
    }
}
