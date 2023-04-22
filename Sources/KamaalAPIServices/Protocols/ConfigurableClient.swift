//
//  ConfigurableClient.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation

public protocol ConfigurableClient {
    associatedtype Configuration

    var configuration: Configuration? { get set }
}

extension ConfigurableClient {
    public mutating func configure(with configuration: Configuration) {
        self.configuration = configuration
    }
}
