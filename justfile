set export

test:
    swift --version

    swift test

format:
    swiftformat .

lint:
    python3 Scripts/swiftlint_checker/main.py

build-example:
    set -o pipefail && xcodebuild -configuration Debug -workspace KamaalSwift.xcworkspace -scheme Example -destination "$DESTINATION" || exit 1
