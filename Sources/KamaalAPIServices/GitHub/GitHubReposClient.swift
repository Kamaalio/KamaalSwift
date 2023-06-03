//
//  File.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation
import KamaalNetworker

public class GitHubReposClient: BaseGitHubClient {
    /// Create issues on a specific repo.
    /// - Parameters:
    ///   - username: the owner of the repo.
    ///   - repoName: name of repo where to create a issue on.
    ///   - title: title of the issue.
    ///   - description: description of the issue.
    ///   - assignee: username of the assignee on the issue.
    ///   - labels: labels on the issue.
    /// - Returns: the created issue if issue creation succeeds or returns a error.
    public func createIssue(
        username: String,
        repoName: String,
        title: String,
        description: String? = nil,
        assignee: String? = nil,
        labels: [String]? = nil
    ) async -> Result<GitHubIssue, GitHubErrors> {
        let url = Self.BASE_URL
            .appendingPathComponent("repos")
            .appendingPathComponent(username)
            .appendingPathComponent(repoName)
            .appendingPathComponent("issues")
        var payload: [String: Any] = [
            "title": title,
        ]
        if let description {
            payload["body"] = description
        }
        if let assignee {
            payload["assignee"] = assignee
        }
        if let labels {
            payload["labels"] = labels
        }
        let config = KRequestConfig(priority: KRequestConfig.defaultPriority, kowalskiAnalysis: false)
        let result: Result<Response<GitHubIssue>, KamaalNetworker.Errors> = await networker.request(
            from: url,
            method: .post,
            payload: payload,
            headers: defaultHeaders,
            config: config
        )

        return result
            .map(\.data)
            .mapError { .fromKamaalNetworker($0) }
    }
}
