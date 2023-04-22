//
//  SettingsConfigurationEnvironment.swift
//
//
//  Created by Kamaal Farah on 24/12/2022.
//

import SwiftUI

extension EnvironmentValues {
    var settingsConfiguration: SettingsConfiguration {
        get { self[SettingsConfigurationKey.self] }
        set { self[SettingsConfigurationKey.self] = newValue }
    }
}

struct SettingsConfigurationKey: EnvironmentKey {
    static let defaultValue: SettingsConfiguration = .default
}
