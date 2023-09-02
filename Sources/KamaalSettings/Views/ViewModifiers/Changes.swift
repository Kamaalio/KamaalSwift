//
//  Changes.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI

extension View {
    public func onAppColorChange(_ perform: @escaping (AppColor) -> Void) -> some View {
        self.onChangeBase(for: .appColorChanged, perform)
    }

    public func onAppIconChange(_ perform: @escaping (AppIcon) -> Void) -> some View {
        self.onChangeBase(for: .appIconChanged, perform)
    }

    public func onFeatureChange(_ perform: @escaping (Feature) -> Void) -> some View {
        self.onChangeBase(for: .featureChanged, perform)
    }

    public func onSettingsPreferenceChange(_ perform: @escaping (Preference) -> Void) -> some View {
        self.onChangeBase(for: .preferenceChanged, perform)
    }

    private func onChangeBase<Target>(for notification: Notification.Name,
                                      _ perform: @escaping (Target) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: notification), perform: { output in
            guard let object = output.object as? Target else { return }
            perform(object)
        })
    }
}
