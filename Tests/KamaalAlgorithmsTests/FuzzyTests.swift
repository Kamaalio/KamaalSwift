//
//  FuzzyTests.swift
//  KamaalSwift
//
//  Created by Kamaal M Farah on 8/16/25.
//

import Testing
import KamaalAlgorithms

@Suite
struct FuzzyStringTests {
    @Test
    func basicCases() async throws {
        // Prefix should be a strong match
        #expect("Hello".fuzzyMatch("he"))
        // Exact match
        #expect("Hello".fuzzyMatch("hello"))
        // Non-match
        #expect(!"Hello".fuzzyMatch(""))
        #expect(!"".fuzzyMatch("he"))
    }

    @Test
    func thresholds() async throws {
        // With default threshold, "kmsw" is an in-order subsequence and should match
        #expect("KamaalSwift".fuzzyMatch("kmsw"))
        // Lowering threshold still allows it
        #expect("KamaalSwift".fuzzyMatch("kmsw", threshold: 0.1))
    }

    @Test
    func properties() async throws {
        // Exact match
        #expect("abc".fuzzyMatch("abc"))
        // Prefix match
        #expect("abcdef".fuzzyMatch("abc"))
        // Characters out of order should not match
        #expect(!"abcdef".fuzzyMatch("cba"))
        // Empty query should not match
        #expect(!"abc".fuzzyMatch(""))
    }
}

private struct Repo { let name: String }

@Suite
struct FuzzyArraySearchTests {
    @Test
    func basic() async throws {
        let repos = [
            Repo(name: "KamaalSwift"),
            Repo(name: "AwesomeKit"),
            Repo(name: "FuzzyFind"),
            Repo(name: "kam-SW"),
        ]

        let results = repos.fuzzySearch("km", by: \.name)
        #expect(results.contains { $0.name == "KamaalSwift" })
        #expect(results.count >= 1)
    }

    @Test
    func sortedAndThreshold() async throws {
        let contacts = [
            Repo(name: "Alice"),
            Repo(name: "Alicia"),
            Repo(name: "Bob"),
        ]

        let scored = contacts.fuzzySearchScores("ali", by: \.name)
        #expect(scored.count == 2)

        // Raise threshold high to filter out
        let none = contacts.fuzzySearchScores("ali", by: \.name, threshold: 0.95)
        #expect(none.isEmpty)
    }

    @Test
    func emptyQuery() async throws {
        let repos = [Repo(name: "KamaalSwift")]
        #expect(repos.fuzzySearch("   ", by: \.name).isEmpty)
        #expect(repos.fuzzySearchScores("\n\t", by: \.name).isEmpty)
    }
}
