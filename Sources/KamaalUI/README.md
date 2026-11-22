# KamaalUI

Small SwiftUI controls and modifiers. Use bindings for values that change
and supply actions for side effects.

| Task | Components |
| --- | --- |
| Compose layouts | `KJustStack`, `KSpacedHStack`, `KTitledView`, `KFormBox`, `KScrollableForm`, `KSection`, `KSheetStack` |
| Enter text and numbers | `KLabeledTextField`, `KFloatingTextField` with `TextFieldType`, `KFloatingDecimalField`, `KEnforcedFloatingDecimalField`, `KTextView` |
| Pick a value | `KTitledPicker`, `KFloatingDatePicker`, `KTimePicker`, `KStepper`, `KRadioCheckBox` |
| Handle actions and progress | `KTappableButton`, `KDeletableView` and `kDeletableView`, `KeyboardShortcutView` and `KeyboardShortcutConfiguration`, `KLoading`, `KCircularProgressBar` |
| Draw and style | `KIsoscelesTriangle`, `kborder`, `kInvisibleFill`, light and dark foreground and background colors, `kSize`, `kBold`, rounded corners on UIKit |
| Measure and fill space | `kBindToFrameSize`, `ktakeSizeEagerly`, `ktakeWidthEagerly` |
| Integrate with UIKit | `KMailView` for mail composition, `endEditing()` to dismiss editing |

```swift
import SwiftUI
import KamaalUI

struct DetailsForm: View {
    var body: some View {
        KScrollableForm {
            KSection(header: "Details") {
                Text("Ready")
            }
        }
    }
}
```

UIKit helpers and mail composition are platform-specific.
[Source and control previews](../../Sources/KamaalUI) · [Example app](../../Example)
