//
//  CloudSubscriptionModule.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation

public class CloudSubscriptionModule {
    private let accounts: CloudAccountsModule
    private let database: CKDatabase

    init(accounts: CloudAccountsModule, database: CKDatabase) {
        self.accounts = accounts
        self.database = database
    }

    public enum Errors: Error { 
        case accountFailure(context: CloudAccountsModule.Errors)
        case fetchFailure(context: Error)
    }

    public func fetchAllSubscriptions() async -> Result<[CKSubscription], Errors> {
        let statusResult = await accounts.getStatus()
            .mapError { error in Errors.accountFailure(context: error) }
        switch statusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        let subscriptions: [CKSubscription]
        do {
            subscriptions = try await database.fetchAllSubscriptions()
        } catch {
            return .failure(.fetchFailure(context: error))
        }

        return .success(subscriptions)
    }
}

extension CKDatabase {
    fileprivate func fetchAllSubscriptions() async throws -> [CKSubscription] {
        try await withCheckedThrowingContinuation { continuation in
            fetchAllSubscriptions { subscriptions, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: subscriptions ?? [])
            }
        }
    }
}
