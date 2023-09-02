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
            ForEach(self.shortcuts) { shortcut in
                Button(action: { self.onEmit(shortcut) }) { EmptyView() }
                    .keyboardShortcut(shortcut.key, modifiers: shortcut.modifiers)
                    .buttonStyle(.borderless)
            }
            self.content
        }
    }
}

public struct KeyboardShortcutConfiguration: Hashable, Identifiable {
    public let modifiers: EventModifiers
    private let keyCharacter: Character

    public init(key: KeyEquivalent, modifiers: EventModifiers = []) {
        self.init(key: key.character, modifers: modifiers)
    }

    private init(key: Character, modifers: EventModifiers = []) {
        self.keyCharacter = key
        self.modifiers = modifers
    }

    public var key: KeyEquivalent { KeyEquivalent(self.keyCharacter) }

    public var id: KeyboardShortcutConfiguration { self }
}

extension EventModifiers: Hashable { }

extension KeyEquivalent: Equatable {
    public static func == (lhs: KeyEquivalent, rhs: KeyEquivalent) -> Bool {
        lhs.character == rhs.character
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
