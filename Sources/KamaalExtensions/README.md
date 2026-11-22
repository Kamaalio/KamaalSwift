# KamaalExtensions

Import `KamaalExtensions` to add these helpers to Swift and Foundation types.

| Types | Helpers |
| --- | --- |
| `Sequence` | Materialize with `asArray`, partition using `chunked`, combine with `concat`, `appended`, and `prepended`, sort and find by key path, `map(_:until:)`, unpack optionals, group results |
| `Array` | `at` for optional indexed access, slicing and removal, in-place `prepend`, `findIndex`, `uniques`, `toSet`, `mappedByID`, `asNSSet`, and key-path sums and averages |
| `Dictionary`, `NSSet` | Query items, merging, key lookup, JSON data, and typed set-to-array conversion |
| `String`, `Character`, `NSString` | Components, trimming, replacement, digit and numeric conversion, case checks, UUID bridging, scrambling, and integer-based ranges |
| `Date` | Calendar components, week and day ranges, comparisons, minute arithmetic, custom and ISO formatting |
| `Optional` | Unwrap against a fallback or throw a supplied error. Add to an optional integer when present. |
| `Bool`, `Int`, `Int64`, `Double`, `UUID`, `CGSize` | Numeric and Foundation bridges, square sizes, decimal formatting, and percentages |
| `URL`, `FileManager`, `Task` | Static URL construction, JSON loading, directory search, and suspending for a duration in seconds |

```swift
import KamaalExtensions

let batches = [1, 2, 3, 4, 5].chunked(2) // [[1, 2], [3, 4], [5]]
let first = batches.at(0)               // Optional([1, 2])
```

Set `includeRemainder: false` for full batches only. Integer-based string
subscripts require valid offsets. Static URL initialization expects a valid
literal. [Source](../../Sources/KamaalExtensions) · [Tests](../../Tests/KamaalExtensionsTests)
