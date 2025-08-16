//
//  Retrier.swift
//
//
//  Created by Kamaal M Farah on 21/01/2024.
//

import Foundation
import KamaalExtensions

public enum Retrier {
    /// Repeats an async operation until it succeeds, waiting longer between attempts.
    ///
    /// The delay grows linearly with the number of retries: `intervalTimeInSeconds * retries`.
    ///
    /// - Parameters:
    ///   - intervalTimeInSeconds: Base wait time in seconds between attempts.
    ///   - completion: The async operation to attempt.
    /// - Returns: The successful result of `completion`.
    /// - Throws: Rethrows the last error only on cancellation; otherwise keeps retrying.
    ///
    /// # Example
    /// ```swift
    /// let data: Data = try await Retrier.retryUntilSuccess(intervalTimeInSeconds: 1.0) {
    ///     try await networkClient.fetch()
    /// }
    /// ```
    public static func retryUntilSuccess<T>(
        intervalTimeInSeconds: TimeInterval,
        completion: () async throws -> T,
    ) async throws -> T {
        try await self.retryUntilSuccess(
            intervalTimeInSeconds: intervalTimeInSeconds,
            retries: 0,
            completion: completion,
        )
    }

    private static func retryUntilSuccess<T>(
        intervalTimeInSeconds: TimeInterval,
        retries: Int,
        completion: () async throws -> T,
    ) async throws -> T {
        do {
            return try await completion()
        } catch { }
        let newRetries = retries + 1
        try await Task.sleep(seconds: intervalTimeInSeconds * TimeInterval(newRetries))

        return try await self.retryUntilSuccess(
            intervalTimeInSeconds: intervalTimeInSeconds,
            retries: newRetries,
            completion: completion,
        )
    }
}
