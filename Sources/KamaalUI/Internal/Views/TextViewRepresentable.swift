//
//  TextViewRepresentable.swift
//
//
//  Created by Kamaal M Farah on 02/04/2022.
//

import SwiftUI

#if canImport(UIKit) && !os(watchOS)
struct TextViewRepresentable: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UIViewType {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewRepresentable

        init(_ parent: TextViewRepresentable) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.$text.wrappedValue = textView.text
        }
    }

    typealias UIViewType = UITextView
}

#elseif canImport(Cocoa)
/// Custom multiline text view for macOS
/// I got a lot of inspiration from this [gist](https://gist.github.com/unnamedd/6e8c3fbc806b8deb60fa65d6b9affab0)
struct TextViewRepresentable: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSViewType {
        let textView = NSViewType(text: text)
        textView.setDelegate(context.coordinator)
        return textView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.setText(self.text)
        nsView.setSelectedRanges(context.coordinator.selectedRanges)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TextViewRepresentable
        var selectedRanges: [NSValue] = []

        init(_ parent: TextViewRepresentable) {
            self.parent = parent
        }

        func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            self.parent.text = textView.string
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            self.parent.text = textView.string
            self.selectedRanges = textView.selectedRanges
        }

        func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            self.parent.text = textView.string
        }
    }

    typealias NSViewType = CustomTextView
}

final class CustomTextView: NSView {
    private var selectedRanges: [NSValue] = [] {
        didSet {
            guard !self.selectedRanges.isEmpty else { return }
            self.textView.selectedRanges = self.selectedRanges
        }
    }

    init(text: String) {
        super.init(frame: .zero)

        self.textView.string = text
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var textView: NSTextView = {
        let contentSize = self.scrollView.contentSize
        let textStorage = NSTextStorage()

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(containerSize: scrollView.frame.size)
        textContainer.widthTracksTextView = true

        let greatestFiniteMagnitude = CGFloat.greatestFiniteMagnitude
        textContainer.containerSize = NSSize(width: contentSize.width, height: greatestFiniteMagnitude)

        layoutManager.addTextContainer(textContainer)

        let textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask = .width
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.drawsBackground = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: greatestFiniteMagnitude, height: greatestFiniteMagnitude)
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.textColor = .labelColor
        textView.allowsUndo = true

        return textView
    }()

    override func viewWillDraw() {
        super.viewWillDraw()

        self.setupScrollViewConstraints()
        self.setupTextView()
    }

    func setSelectedRanges(_ ranges: [NSValue]) {
        self.selectedRanges = ranges
    }

    func setDelegate(_ delegate: NSTextViewDelegate) {
        self.textView.delegate = delegate
    }

    func setText(_ text: String) {
        self.textView.string = text
    }

    private func setupScrollViewConstraints() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(self.scrollView)

        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }

    private func setupTextView() {
        self.scrollView.documentView = self.textView
    }
}
#endif
