# KamaalLogger

Log a short message at `info`, `warning`, `error`, or `debug` severity.
Use named fields for values that a viewer needs to display, copy, or decode.

```swift
import KamaalLogger

struct Page: Encodable {
    let count: Int
    let isCached: Bool
}

let holder = LogHolder()
let logger = KamaalLogger(label: "Collection", holder: holder)
logger.info("Collection loaded", fields: [
    .init("source", "cache", privacy: .public),
    .init("page", object: Page(count: 12, isCached: true), privacy: .public),
])
let entry = await holder.logs.last
let displayFields = entry?.fields()
let jsonObjects = try entry?.jsonObjects()
```

| API | Behavior |
| --- | --- |
| `LogHolder` | Entries are available after the call returns. Reads are oldest first. The default buffer keeps 100 entries. Pass `nil` for an unlimited buffer or a nonpositive size for console-only logging. |
| `HoldedLog.fields()` | Returns public fields in insertion order, including repeated names. Use `field.value.displayText` for display or copy. |
| `HoldedLog.jsonObjects()` | Returns the visible encoded objects in order. When none are visible, returns one object such as `{"message":"Collection loaded"}`. |
| `LogField` | Stores text or an `Encodable` value as formatted JSON. Failed encoding produces a marker and the remaining entry is still captured. |
| `@LogValue` | Records initialization, reads, and writes at the chosen `LogLevels` severity. Use it with values that are safe to log. |

Fields default to private. Only trusted developer tooling should use
`includingPrivate: true`. Choose safe log messages and field names, since the
message itself is plain text. Debug entries are recorded only in Debug builds.
`failOnError` enables a debug assertion after recording an error.

[Source](../../Sources/KamaalLogger) · [Examples and tests](../../Tests/KamaalLoggerTests)
