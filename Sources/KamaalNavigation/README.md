# KamaalNavigation

Use `NavigationStackView` to host an app's destinations, with a sidebar
on macOS and iPad, and tab navigation on iPhone.

1. Define a `NavigatorStackValue` enum with a root, tab membership,
   titles, and symbol names. Implement `view(_:)` to render each screen.
2. Pass an initial path and sidebar builder to `NavigationStackView`.
   Use `passthroughEnvironment` to attach environment values to routed views
   and `handleURLOpen` to map incoming links to a destination.
3. Read the injected `Navigator<Screen>` as an environment object.

```swift
import SwiftUI
import KamaalNavigation

enum Screen: String, NavigatorStackValue {
    case home, detail

    static let root = Self.home
    var isTabItem: Bool { self == .home }
    var imageSystemName: String { "house" }
    var title: String { rawValue.capitalized }

    func view(_ isSub: Bool) -> some View {
        switch self {
        case .home:
            StackNavigationLink(destination: Screen.detail) { Text("Open detail") }
        case .detail:
            Text("Detail").navigationTitle(title: title, displayMode: .inline)
        }
    }
}

struct AppNavigation: View {
    var body: some View {
        NavigationStackView(initialStack: [Screen](), sidebar: { Text("Home") }) { $0 }
    }
}
```

| API | Action |
| --- | --- |
| `StackNavigationLink` / `navigate(to:)` | Push a destination onto the current stack |
| `StackNavigationChangeStackButton` / `changeStack(to:)` | Switch stacks while preserving each stack's path |
| `StackNavigationBackButton` / `goBack()` | Pop the current stack |
| `currentScreen` | Read the top destination, if present |
| `navigationTitle(title:displayMode:)` | Apply a title with the platform's supported title presentation |

[Example screen enum](../../Example/Example/Screens.swift) ·
[Example navigation root](../../Example/Example/ContentView.swift) ·
[Source](../../Sources/KamaalNavigation)
