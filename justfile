set export

test:
    swift test

format:
    swiftformat .

lint:
    python3 Scripts/swiftlint_checker/main.py
