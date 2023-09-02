//
//  Preference.swift
//
//
//  Created by Kamaal M Farah on 03/01/2023.
//

import Foundation

public struct Preference: Hashable, Identifiable, Codable {
    public let id: UUID
    public let label: String
    public let selectedOption: Option
    public let options: [Option]

    public init(id: UUID, label: String, selectedOption: Option, options: [Option]) {
        self.id = id
        self.label = label
        self.selectedOption = selectedOption
        self.options = options
    }

    public struct Option: Hashable, Identifiable, Codable {
        public let id: UUID
        public let label: String

        public init(id: UUID, label: String) {
            self.id = id
            self.label = label
        }
    }

    var optionsContainSelectedOption: Bool {
        self.options.contains(self.selectedOption)
    }

    func setOption(_ option: Option) -> Preference {
        .init(id: self.id, label: self.label, selectedOption: option, options: self.options)
    }
}
