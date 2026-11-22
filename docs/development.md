# Develop and test

Use Xcode with Swift 6.1 or later, `just`, Python 3, SwiftLint, and SwiftFormat.
Initialize the lint checker submodule before running lint.

```sh
git submodule update --init --recursive
just --list
just lint
just test
```

- `just test` runs the Swift package suites with coverage. Keychain and
  StoreKit tests use Apple system services on the test host.
- `swift test --filter KamaalLoggerTests` runs one suite. Tests live under
  [Tests](../Tests), grouped by module.
- `just format` runs SwiftFormat. CI uses the
  [checked-in workflow](../.github/workflows/ci.yml).
- Open [KamaalSwift.xcworkspace](../KamaalSwift.xcworkspace) and select
  the **Example** scheme to run the sample. The `build-example` and
  `xcode-test` recipes use `DESTINATION` and `SDK` from the environment
  and format output through `xcpretty`.
