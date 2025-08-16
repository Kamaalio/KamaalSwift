//
//  Retrier.swift
//
//
//  Created by Kamaal M Farah on 21/01/2024.
//

import Foundation
import KamaalExtensions

public enum Retrier {
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
