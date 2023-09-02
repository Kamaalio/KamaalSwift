//
//  GitHubClient.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation
import KamaalExtensions

public struct GitHubClient: ConfigurableClient {
    public var configuration: GitHubClientConfiguration? {
        didSet { self.configurationDidSet() }
    }

    public var repos = GitHubReposClient()

    init() { }

    private mutating func configurationDidSet() {
        if let configuration {
            self.repos.configure(with: configuration)
        }
    }
}
