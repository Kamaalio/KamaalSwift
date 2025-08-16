//
//  Fuzzy.swift
//  KamaalSwift
//
//  Created by Kamaal M Farah on 8/16/25.
//

import Foundation
import KamaalExtensions

/// Default threshold used for fuzzy matching and searching.
///
/// The threshold represents the minimum score required (0.0 - 1.0) for a value to be
/// considered a match. Higher values are stricter.
///
/// - Note: Tuned for a good balance between recall and precision for short strings.
///
/// # Example
/// ```swift
/// let isMatch = "Hello World".fuzzyMatch("he wo", threshold: DEFAULT_FUZZY_SEARCH_THRESHOLD)
/// // isMatch == true for the default threshold
/// ```
public let DEFAULT_FUZZY_SEARCH_THRESHOLD = 0.3

extension String {
    /// Calculates the fuzzy search score between this string and a query
    /// Returns a score between 0.0 (no match) and 1.0 (perfect match)
    func fuzzyScore(for query: String) -> Double {
        let normalizedSelf = self.lowercased()
        let normalizedQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else { return 0.0 }
        guard !normalizedSelf.isEmpty else { return 0.0 }

        // Perfect match gets highest score
        if normalizedSelf == normalizedQuery {
            return 1.0
        }

        // Prefix match gets high score
        if normalizedSelf.hasPrefix(normalizedQuery) {
            return 0.9
        }

        // Calculate character-by-character fuzzy match
        let selfChars = Array(normalizedSelf)
        let queryChars = Array(normalizedQuery)

        var matches = 0
        var queryIndex = 0
        var consecutiveMatches = 0
        var maxConsecutiveMatches = 0
        for char in selfChars {
            if queryIndex < queryChars.count, char == queryChars[queryIndex] {
                matches += 1
                queryIndex += 1
                consecutiveMatches += 1
                maxConsecutiveMatches = max(maxConsecutiveMatches, consecutiveMatches)
            } else {
                consecutiveMatches = 0
            }
        }

        // All query characters must be found in order
        guard matches == queryChars.count else { return 0.0 }

        // Calculate score based on match quality
        let matchRatio = Double(matches) / Double(queryChars.count)
        let lengthRatio = Double(queryChars.count) / Double(selfChars.count)
        let consecutiveBonus = Double(maxConsecutiveMatches) / Double(queryChars.count)

        // Combine factors for final score
        let score = (matchRatio * 0.4) + (lengthRatio * 0.3) + (consecutiveBonus * 0.3)

        return min(score, 0.8) // Cap at 0.8 to leave room for prefix matches
    }

    /// Checks if the string fuzzily matches the given query.
    ///
    /// A fuzzy match succeeds when the computed fuzzy score is greater than or equal to the
    /// provided threshold. Matching is case-insensitive and ignores surrounding whitespace in the query.
    ///
    /// - Parameters:
    ///   - query: The query string to match against.
    ///   - threshold: Minimum score required for a match, between `0.0` and `1.0`. Defaults to
    /// `DEFAULT_FUZZY_SEARCH_THRESHOLD`.
    /// - Returns: `true` if the fuzzy score is at least `threshold`, otherwise `false`.
    ///
    /// # Examples
    /// ```swift
    /// "KamaalSwift".fuzzyMatch("kz")              // false for default threshold ("z" not present)
    /// "KamaalSwift".fuzzyMatch("kama", threshold: 0.2) // true with a lower threshold
    /// "Hello".fuzzyMatch("he")                     // true (prefix gets high score)
    /// ```
    public func fuzzyMatch(_ query: String, threshold: Double = DEFAULT_FUZZY_SEARCH_THRESHOLD)
        -> Bool {
        self.fuzzyScore(for: query) >= threshold
    }
}

public struct FuzzySearchResult<T> {
    let item: T
    let score: Double
}

extension Array {
    /// Fuzzily searches this array for items whose text at `keyPath` matches `query`.
    ///
    /// - Parameters:
    ///   - query: The query to fuzzy match on. Leading/trailing whitespace is ignored.
    ///   - keyPath: The key path to a string (or string-like) property to search.
    ///   - threshold: The minimum score for inclusion. Defaults to `DEFAULT_FUZZY_SEARCH_THRESHOLD`.
    /// - Returns: An array of elements that meet or exceed the threshold, sorted by descending score.
    ///
    /// # Example
    /// ```swift
    /// struct Repo { let name: String }
    /// let repos = [Repo(name: "KamaalSwift"), Repo(name: "AwesomeKit"), Repo(name: "FuzzyFind")]
    /// let results = repos.fuzzySearch("km", by: \ .name)
    /// // results contains likely matches like "KamaalSwift"
    /// ```
    public func fuzzySearch(
        _ query: String,
        by keyPath: KeyPath<Element, some StringProtocol>,
        threshold: Double = DEFAULT_FUZZY_SEARCH_THRESHOLD,
    ) -> [Element] {
        self.fuzzySearchScores(query, by: keyPath, threshold: threshold)
            .map(\.item)
    }

    /// Like ``fuzzySearch(_:by:threshold:)`` but returns the score for each item.
    ///
    /// - Parameters:
    ///   - query: The query to fuzzy match on.
    ///   - keyPath: The key path to a string (or string-like) property to search.
    ///   - threshold: The minimum score for inclusion.
    /// - Returns: A list of ``FuzzySearchResult`` containing the element and its score, sorted by descending score.
    ///
    /// # Example
    /// ```swift
    /// struct Contact { let displayName: String }
    /// let contacts = [Contact(displayName: "Alice"), Contact(displayName: "Alicia"), Contact(displayName: "Bob")]
    /// let scored = contacts.fuzzySearchScores("ali", by: \ .displayName)
    /// // scored.first?.item => "Alice" or "Alicia" depending on score
    /// // scored.first?.score => a Double between 0.0 and 1.0
    /// ```
    public func fuzzySearchScores(
        _ query: String,
        by keyPath: KeyPath<Element, some StringProtocol>,
        threshold: Double = DEFAULT_FUZZY_SEARCH_THRESHOLD,
    ) -> [FuzzySearchResult<Element>] {
        let normalizedQuery = query.trimmingByWhitespacesAndNewLines
        guard !normalizedQuery.isEmpty else { return [] }

        return
            self
                .compactMap { item -> FuzzySearchResult<Element>? in
                    let text = String(item[keyPath: keyPath])
                    let score = text.fuzzyScore(for: normalizedQuery)
                    guard score >= threshold else { return nil }

                    return FuzzySearchResult(item: item, score: score)
                }
                .sorted(by: \.score, using: .orderedDescending)
    }
}
