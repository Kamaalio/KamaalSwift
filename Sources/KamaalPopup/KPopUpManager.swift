//
//  KPopUpManager.swift
//
//
//  Created by Kamaal M Farah on 22/12/2021.
//

import SwiftUI

public final class KPopUpManager: ObservableObject {
    @Published var isShown = false
    @Published var style: KPopUpStyles = .bottom(title: "", type: .success, description: nil)
    @Published var config: KPopUpConfig
    @Published private var lastTimeout: TimeInterval? {
        didSet { lastTimeoutDidSet() }
    }

    private var timeoutTimer: Timer?

    public init(config: KPopUpConfig = .init()) {
        self.config = config
    }

    var title: String {
        switch style {
        case .bottom(title: let title, type: _, description: _): return title
        case .hud(title: let title, systemImageName: _, description: _): return title
        }
    }

    var description: String? {
        switch style {
        case .bottom(title: _, type: _, description: let description): return description
        case .hud(title: _, systemImageName: _, description: let description): return description
        }
    }

    var systemImageName: String? {
        switch style {
        case .bottom: return nil
        case .hud(title: _, systemImageName: let systemImageName, description: _): return systemImageName
        }
    }

    var bottomType: KPopUpBottomType? {
        switch style {
        case .bottom(title: _, type: let type, description: _): return type
        case .hud: return nil
        }
    }

    public func showPopUp(
        style: KPopUpStyles,
        timeout: TimeInterval? = nil
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.style = style
            withAnimation(.easeOut(duration: 0.5)) { self.isShown = true }
            self.lastTimeout = timeout
        }
    }

    public func hidePopUp() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            withAnimation(.easeIn(duration: 0.8)) { self.isShown = false }
            self.lastTimeout = nil
            self.timeoutTimer?.invalidate()
        }
    }

    public func setConfig(with config: KPopUpConfig) {
        self.config = config
    }

    private func lastTimeoutDidSet() {
        guard let lastTimeout = lastTimeout else { return }
        let timeoutTimer = Timer.scheduledTimer(
            timeInterval: lastTimeout,
            target: self,
            selector: #selector(handleTimeout),
            userInfo: nil,
            repeats: false
        )
        self.timeoutTimer = timeoutTimer
    }

    @objc
    private func handleTimeout(_: Timer?) {
        timeoutTimer?.invalidate()
        hidePopUp()
    }
}
