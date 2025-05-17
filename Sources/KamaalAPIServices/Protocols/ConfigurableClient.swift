//
//  ConfigurableClient.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation

public protocol ConfigurableClient: Sendable {
    associatedtype Configuration: Sendable

    var configuration: Configuration? { get }

    mutating func configure(with configuration: Configuration)
}
