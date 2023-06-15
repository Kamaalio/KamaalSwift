//
//  KeyboardShortcutView.swift
//
//
//  Created by Kamaal M Farah on 15/06/2023.
//

#if !os(watchOS)
import SwiftUI

public struct KeyboardShortcutView<Content: View>: View {
    let shortcuts: [KeyboardShortcutConfiguration]
    let content: Content
    let onEmit: (_ shortcut: KeyboardShortcutConfiguration) -> Void

    public init(
        shortcuts: [KeyboardShortcutConfiguration],
        onEmit: @escaping (_ shortcut: KeyboardShortcutConfiguration) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.shortcuts = shortcuts
        self.content = content()
        self.onEmit = onEmit
    }

    public var body: some View {
        ZStack {
            ForEach(shortcuts) { shortcut in
                Button(action: { onEmit(shortcut) }) { EmptyView() }
                    .keyboardShortcut(shortcut.key, modifiers: shortcut.modifiers)
                    .buttonStyle(.borderless)
            }
            content
        }
    }
}

public struct KeyboardShortcutConfiguration: Hashable, Identifiable {
    public let key: KeyEquivalent
    public let modifiers: EventModifiers

    public init(key: KeyEquivalent, modifiers: EventModifiers = []) {
        self.key = key
        self.modifiers = modifiers
    }

    public var id: KeyboardShortcutConfiguration { self }
}

extension EventModifiers: Hashable { }

extension KeyEquivalent: Equatable {
    public static func == (lhs: KeyEquivalent, rhs: KeyEquivalent) -> Bool {
        lhs.character == rhs.character
    }
}

extension KeyEquivalent: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(character)
    }
}

struct KeyboardShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardShortcutView(shortcuts: [], onEmit: { _ in }, content: {
            Text("Content")
        })
    }
}
#endif
