//
//  NotificationName+extensions.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import Foundation

extension Notification.Name {
    static let appColorChanged = makeNotificationName(withKey: "app_color_changed")
    static let appIconChanged = makeNotificationName(withKey: "app_icon_changed")
    static let featureChanged = makeNotificationName(withKey: "feature_changed")
    static let preferenceChanged = makeNotificationName(withKey: "preference_changed")

    private static func makeNotificationName(withKey key: String) -> Notification.Name {
        Notification.Name("io.kamaal.KamaalSettings.notifications.\(key)")
    }
}
