# KamaalBrowser

Attach a link to a SwiftUI view. The modifier presents Safari inside the app on
iOS and opens the system browser on macOS.

```swift
import SwiftUI
import KamaalBrowser

struct HelpButton: View {
    let helpURL: URL
    @State private var showingHelp = false

    var body: some View {
        Button("Help") { showingHelp = true }
            .kBrowser(isPresented: $showingHelp, url: helpURL)
    }
}
```

- Use `kBrowser(isPresented:url:color:)` for a fixed URL. Set the Boolean
  binding when the user requests the link.
- Use `kBrowser(_:fallbackURL:color:)` for a destination selected at runtime.
  Assign a URL to the optional binding to open it. The modifier clears the
  selection after dismissal on iOS or after opening the browser on macOS.
- The color configures Safari's controls on iOS.

[Source and usage examples](../../Sources/KamaalBrowser/KamaalBrowser.swift)
