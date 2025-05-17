//
//  GitHubClient.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation
import KamaalExtensions

public struct GitHubClient: ConfigurableClient {
    public var configuration: GitHubClientConfiguration?

    public var repos = GitHubReposClient()

    init() { }

    public mutating func configure(with configuration: GitHubClientConfiguration) {
        self.repos.configure(with: configuration)
    }
}
