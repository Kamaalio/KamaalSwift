# KamaalPopUp

Present short feedback as a top HUD or a bottom card.

```swift
import SwiftUI
import KamaalPopUp

struct SaveButton: View {
    @State private var saved = false

    var body: some View {
        Button("Save") { saved = true }
            .kPopUpLite(
                isPresented: $saved,
                style: .bottom(title: "Saved", type: .success, description: nil),
                backgroundColor: .white
            )
    }
}
```

Use `withKPopUp(_:)` with a `KPopUpManager` when multiple views share the
presenter. Call `showPopUp(style:timeout:)` and `hidePopUp()` to control it,
or `setConfig(with:)` to update its background. The binding-based
`kPopUpLite` also accepts an optional close callback through a separate overload.

`KPopUpStyles.hud` takes an SF Symbol name. Bottom styles use
`KPopUpBottomType` with success, warning, or error colors and icons.
[Source](../../Sources/KamaalPopUp)
