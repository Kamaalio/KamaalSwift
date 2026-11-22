# KamaalStructures

| Type | Use |
| --- | --- |
| `Queue<T>` | FIFO buffer with `enqueue` and `dequeue`. Supply a positive `max` to evict the oldest item when full, or `nil` for an unbounded queue. |
| `Stack<Value>` | LIFO storage with `push`, `pop`, `peek`, and `fromArray`. Requires `Codable & Hashable` values. |
| `Node<Value>` | A Codable linked node with a value and optional next node. `array` returns the chain from tail to head. |

```swift
import KamaalStructures

var queue = Queue<String>(max: 2)
queue.enqueue("first")
queue.enqueue("second")
queue.enqueue("third")
let next = queue.dequeue() // "second"
```

The queue's `array` reads oldest to newest. The stack's `array` reads
bottom to top. Both expose `count` and `isEmpty`. [Source](../../Sources/KamaalStructures)
