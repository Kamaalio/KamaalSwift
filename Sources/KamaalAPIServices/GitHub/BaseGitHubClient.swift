//
//  BaseGitHubClient.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation
import KamaalNetworker
import KamaalExtensions

public class BaseGitHubClient: ConfigurableClient {
    public var configuration: GitHubClientConfiguration? {
        didSet { self.configurationDidSet() }
    }

    var networker = KamaalNetworker()

    static let BASE_URL = URL(staticString: "https://api.github.com")

    init() { }

    var defaultHeaders: [String: String] {
        var headers = [
            "accept": "application/vnd.github.v3+json",
        ]

        guard let configuration else {
            assertionFailure("Should have configure client first")
            return headers
        }

        if let login = "\(configuration.username):\(configuration.token)".data(using: .utf8) {
            headers["Authorization"] = "Basic \(login.base64EncodedString())"
        }

        return headers
    }

    private func configurationDidSet() {
        guard let configuration else { return }

        self.networker = .init(urlSession: configuration.urlSession)
    }
}
