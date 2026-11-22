# KamaalAlgorithms

Fuzzy matching for strings and arrays of searchable items.

```swift
import KamaalAlgorithms

struct Project { let name: String }

let projects = [Project(name: "KamaalSwift"), Project(name: "Other")]
let matches = projects.fuzzySearch("kama", by: \.name)
```

- `String.fuzzyMatch(_:threshold:)` checks whether one string meets the threshold.
- `Array.fuzzySearch(_:by:threshold:)` returns matching items in descending
  score order. An empty query returns an empty list.
- `fuzzySearchScores` returns `FuzzySearchResult` wrappers. In v3.6.0 the
  wrapper's item and score are module-internal. Use `fuzzySearch` to read
  matching items from another module.

Matching ignores case and trims surrounding query whitespace. Exact and prefix
matches rank ahead of other ordered character matches. The default threshold is
`0.3`. [Source](../../Sources/KamaalAlgorithms/Fuzzy.swift)
