# KamaalCloud

Access CloudKit with an app configured for the target container. Initialize
`KamaalCloud(containerID:databaseType:)` with the container identifier and
choose `.private`, `.shared`, or `.public`.

```swift
import CloudKit
import KamaalCloud

func loadNotes(containerID: String) async throws -> [CKRecord] {
    let cloud = KamaalCloud(containerID: containerID, databaseType: .private)
    return try await cloud.objects.list(ofType: "Note").get()
}
```

| Surface | Operations |
| --- | --- |
| `objects` | `list(ofType:)`, `find(ofType:by:)`, `filter(ofType:by:)` |
| `objects` | Save or delete one or more `CKRecord`s, or use `deleteAndSave` for a combined operation |
| `subscriptions` | Subscribe to changes for one or more record types or fetch existing subscriptions |

Operations return async `Result` values. Object queries use CloudKit
predicates, and `find` returns an optional match. Subscriptions are CloudKit
subscriptions. Notification delivery and handling belong to the app.

Account checks run internally before database operations. The modules expose
operation-specific errors, including account failures and their underlying
CloudKit context. [Source](../../Sources/KamaalCloud)
