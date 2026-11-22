# KamaalSwift

A description of this package.

## Structured logs

`KamaalLogger` accepts ordered fields with any severity. Mark values that
can be displayed or copied as public. Omitted privacy defaults to private.

```swift
import KamaalLogger

struct Page: Encodable {
    let resultCount: Int
    let isCached: Bool
}

let holder = LogHolder()
let logger = KamaalLogger(label: "Collection", holder: holder)
logger.info("Collection loaded", fields: [
    .init("source", "cache", privacy: .public),
    .init("page", object: Page(resultCount: 12, isCached: true), privacy: .public),
])
let entries = await holder.logs
let displayFields = entries.last?.fields()
let jsonObjects = try entries.last?.jsonObjects()
```

`fields()` preserves order and repeated names. Object fields contain
pretty-printed JSON data that a viewer can render, copy, or decode via
`JSONDecoder`. Public fields also appear in console messages. A trusted
developer view can request `fields(includingPrivate: true)` for the
original field values. Keep secrets out of logs and use safe text for the
message and field names.
Existing string messages retain their original format. App-specific
redaction still applies to legacy messages.


`jsonObjects()` returns the visible payloads in field order. When an
entry has no visible JSON payloads, it returns one object with the
original message under the `message` key.
