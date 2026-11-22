# KamaalSettings

Build settings from a `SettingsConfiguration`. Install it with
`settingsEnvironment(configuration:)`, show `SettingsScreen`, and map its
`SettingsScreenSelection` values into your `NavigatorStackValue`. Use
`SettingsScreenSelectionView` to render the library's routed screens.

```swift
import SwiftUI
import KamaalNavigation
import KamaalSettings

struct AppSettings<Screen: NavigatorStackValue>: View {
    let screenMapping: (SettingsScreenSelection) -> Screen
    let preferences: [Preference]
    let preferenceChanged: (Preference) -> Void

    var body: some View {
        SettingsScreen(screenMapping: screenMapping)
            .settingsEnvironment(configuration: .init(preferences: preferences))
            .onSettingsPreferenceChange(preferenceChanged)
    }
}
```

| Configuration | Models |
| --- | --- |
| Personalization | `ColorsConfiguration` with `AppColor`, `AppIconConfiguration` with `AppIcon` |
| Preferences and feature switches | `Preference` and its `Option`, and `Feature` |
| About and acknowledgements | `Acknowledgements` with `Package` and `Contributor` |
| Donations | `StoreKitDonation`, configured with an app product identifier |
| Feedback | `FeedbackConfiguration` for a GitHub repository, labels, and optional extra data |
| Logs | `showLogs` controls the built-in viewer of `LogHolder.shared` |

Handle changes with `onAppColorChange`, `onAppIconChange`, `onFeatureChange`,
and `onSettingsPreferenceChange`. Apply and persist them in your app. The
configuration omits a preference whose selected option is absent from its options.

The built-in log screen shows the entry message. Its bug report action puts
that message in the feedback draft. Use safe messages on this surface. A
custom viewer can use [KamaalLogger's field and JSON accessors](../../Sources/KamaalLogger/README.md)
to handle structured values.

[Example settings screen](../../Example/Example/Views/Screens/AppSettings.swift) ·
[Example configuration](../../Example/Example/UserSettings.swift) ·
[Source](../../Sources/KamaalSettings)
