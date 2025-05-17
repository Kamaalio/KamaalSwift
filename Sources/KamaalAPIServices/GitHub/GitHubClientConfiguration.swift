//
//  GitHubClientConfiguration.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation

public struct GitHubClientConfiguration: Sendable {
    public var token: String
    public var username: String
    public var urlSession: URLSession

    public init(token: String, username: String, urlSession: URLSession = .shared) {
        self.token = token
        self.username = username
        self.urlSession = urlSession
    }
}
