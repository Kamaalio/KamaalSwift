# KamaalUtils

| Need | API |
| --- | --- |
| Store small values or Codable settings | `@UserDefaultsValue` and `@UserDefaultsObject` accept a key and defaults container. Call `removeValue()` on the projected value to clear it. |
| Store bytes securely | `Keychain.set`, `get`, and `delete` use typed `Result` errors. A missing item is a successful read with a nil value. |
| Read a bundled JSON file | `JSONFileUnpacker<Content>` decodes a named resource from the supplied bundle and exposes `content`. |
| Manage files and directories | `FileClerk` looks up the library directory, creates files or directories, removes items, and moves folder contents. Check availability on folder methods. |
| Retry work | `Retrier.retryUntilSuccess` retries a throwing operation until it succeeds or its delay is cancelled. Each retry adds one base interval to the delay. |
| Save a file on macOS | `SavePanel.save(filename:)` returns the selected panel or a cancellation or response error. The caller writes the file. |
| Run a macOS process | `Shell.zsh`, `appleScript`, and `shell` report process output and pipe errors. The shell methods support environment variables and a working directory. |

```swift
import KamaalUtils

struct Preferences {
    @UserDefaultsValue(key: "showTips") var showTips: Bool?
}

let preferences = Preferences()
preferences.showTips = true
let showTips = preferences.showTips ?? false
preferences.$showTips.removeValue()
```

[Source](../../Sources/KamaalUtils) · [Tests](../../Tests/KamaalUtilsTests)
