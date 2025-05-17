//
//  KPopUpManager.swift
//
//
//  Created by Kamaal M Farah on 22/12/2021.
//

import SwiftUI

@MainActor
public final class KPopUpManager: ObservableObject {
    @Published var isShown = false
    @Published var style: KPopUpStyles = .bottom(title: "", type: .success, description: nil)
    @Published var config: KPopUpConfig
    @Published private var lastTimeout: TimeInterval? {
        didSet { self.lastTimeoutDidSet() }
    }

    private var timeoutTimer: Timer?

    public init(config: KPopUpConfig = .init()) {
        self.config = config
    }

    var title: String {
        switch self.style {
        case .bottom(title: let title, type: _, description: _): title
        case .hud(title: let title, systemImageName: _, description: _): title
        }
    }

    var description: String? {
        switch self.style {
        case .bottom(title: _, type: _, description: let description): description
        case .hud(title: _, systemImageName: _, description: let description): description
        }
    }

    var systemImageName: String? {
        switch self.style {
        case .bottom: nil
        case .hud(title: _, systemImageName: let systemImageName, description: _): systemImageName
        }
    }

    var bottomType: KPopUpBottomType? {
        switch self.style {
        case .bottom(title: _, type: let type, description: _): type
        case .hud: nil
        }
    }

    public func showPopUp(
        style: KPopUpStyles,
        timeout: TimeInterval? = nil
    ) {
        self.style = style
        withAnimation(.easeOut(duration: 0.5)) { self.isShown = true }
        self.lastTimeout = timeout
    }

    public func hidePopUp() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            withAnimation(.easeIn(duration: 0.8)) { self.isShown = false }
            self.lastTimeout = nil
            self.timeoutTimer?.invalidate()
        }
    }

    public func setConfig(with config: KPopUpConfig) {
        self.config = config
    }

    private func lastTimeoutDidSet() {
        guard let lastTimeout else { return }
        let timeoutTimer = Timer.scheduledTimer(
            timeInterval: lastTimeout,
            target: self,
            selector: #selector(self.handleTimeout),
            userInfo: nil,
            repeats: false
        )
        self.timeoutTimer = timeoutTimer
    }

    @objc
    private func handleTimeout(_: Timer?) {
        self.timeoutTimer?.invalidate()
        self.hidePopUp()
    }
}
