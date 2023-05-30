set export

WORKSPACE := "KamaalSwift.xcworkspace"
EXAMPLE_SCHEME := "Example"

test:
    #!/bin/sh

    swift --version
    swift test --enable-code-coverage

xcode-test:
    #!/bin/sh

    xcodebuild -scheme "$EXAMPLE_SCHEME" -configuration Debug -workspace  "$WORKSPACE" -sdk "$SDK" -destination "$DESTINATION" build test | xcpretty && exit ${PIPESTATUS[0]}

format:
    swiftformat .

lint:
    python3 Scripts/swiftlint_checker/main.py

build-example:
    #!/bin/sh

    xcodebuild -configuration Debug -workspace "$WORKSPACE" -scheme $EXAMPLE_SCHEME -destination "$DESTINATION" | xcpretty && exit ${PIPESTATUS[0]}
