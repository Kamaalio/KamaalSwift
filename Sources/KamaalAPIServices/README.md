# KamaalAPIServices

Configure the GitHub client to create repository issues.

```swift
import KamaalAPIServices

func reportIssue(token: String) async throws -> GitHubIssue {
    var gitHub = KamaalAPIServices().gitHub
    gitHub.configure(with: .init(token: token, username: "reporter"))
    return try await gitHub.repos.createIssue(
        username: "repository-owner",
        repoName: "project",
        title: "Unexpected result"
    ).get()
}
```

`GitHubClientConfiguration` accepts a custom `URLSession`.
`ConfigurableClient` defines the configuration interface.
`GitHubReposClient.createIssue` also accepts a description, assignee, and labels.
It returns a `Result<GitHubIssue, GitHubErrors>`. Issue models include user,
label, and reaction data. Supply a credential authorized for the destination
repository and load it at runtime. [Source](../../Sources/KamaalAPIServices) ·
[Request tests](../../Tests/KamaalAPIServicesTests)
