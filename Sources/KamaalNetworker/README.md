# KamaalNetworker

Make a request and decode the reply into a Swift type. Inject a `URLSession`
when the caller owns networking configuration or needs a custom test transport.

```swift
import Foundation
import KamaalNetworker

struct Record: Decodable, Sendable {
    let title: String
}

func loadRecord() async throws -> Record {
    let client = KamaalNetworker()
    let result: Result<Response<Record>, KamaalNetworker.Errors> =
        await client.request(from: URL(string: "https://example.com/record")!, payload: nil as Data?)
    return try result.get().data
}
```

- `request` takes a URL or URL string. Use raw data or a
  JSON dictionary for the body. Supply headers, an `HTTPMethod`, and optional
  `KRequestConfig` for task priority and response analysis.
- Choose async `Result`, a completion handler, or `requestPublisher` when
  Combine is available. `Response` carries decoded data and an optional status.
- `requestData` and `loadImage` are synchronous byte reads. Keep them off the
  main actor for remote URLs.
- Inspect `KamaalNetworker.Errors` for URL, transport, response, and parsing
  failures. [Source](../../Sources/KamaalNetworker) · [Tests](../../Tests/KamaalNetworkerTests)
