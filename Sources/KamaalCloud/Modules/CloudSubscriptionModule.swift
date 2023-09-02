//
//  CloudSubscriptionModule.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation

public class CloudSubscriptionModule {
    public private(set) var fetchedSubscriptions: [CKSubscription] = []

    private let accounts: CloudAccountsModule
    private let database: CKDatabase
    private var fetchingSubscriptions = false

    init(accounts: CloudAccountsModule, database: CKDatabase) {
        self.accounts = accounts
        self.database = database
    }

    public enum Errors: Error {
        case accountFailure(context: CloudAccountsModule.Errors)
        case fetchFailure(context: Error)
    }

//    public func subscribe(toType objectType: String,
//                          by predicate: NSPredicate) async -> Result<CKSubscription, Errors> {
//        let statusResult = await accounts.getStatus()
//            .mapError { error in Errors.accountFailure(context: error) }
//        switch statusResult {
//        case let .failure(failure): return .failure(failure)
//        case .success: break
//        }
//
//        let subscriptionOptions: CKQuerySubscription.Options = [
//            .firesOnRecordCreation,
//            .firesOnRecordDeletion,
//            .firesOnRecordUpdate,
//        ]
//        #error("Get the real subscription")
//        let subscriptionQuery = CKQuerySubscription(
//            recordType: objectType,
//            predicate: predicate,
//            subscriptionID: fetchedSubscriptions.first!.subscriptionID,
//            options: subscriptionOptions
//        )
//        let notification = CKSubscription.NotificationInfo()
//        notification.shouldSendContentAvailable = true
//        subscriptionQuery.notificationInfo = notification
//        fatalError()
//    }

    public func fetchAllSubscriptions() async -> Result<[CKSubscription], Errors> {
        if fetchingSubscriptions {
            let subscriptions = await getFetchingSubscriptions()
            return .success(subscriptions)
        }

        return await withFetchingSubscriptions { [weak self] in
            guard let self else { fatalError() }

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

            fetchedSubscriptions = subscriptions
            return .success(subscriptions)
        }
    }

    private func getFetchingSubscriptions() async -> [CKSubscription] {
        await withCheckedContinuation { continuation in
            getFetchingSubscriptions { subscriptions in
                continuation.resume(returning: subscriptions)
            }
        }
    }

    private func getFetchingSubscriptions(completion: @escaping ([CKSubscription]) -> Void) {
        guard fetchingSubscriptions else {
            completion(fetchedSubscriptions)
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
            guard let self else { fatalError() }

            if !self.fetchingSubscriptions {
                timer.invalidate()
                completion(self.fetchedSubscriptions)
            }
        }
    }

    private func withFetchingSubscriptions<T>(completion: @escaping () async -> T) async -> T {
        fetchingSubscriptions = true
        let result = await completion()
        fetchingSubscriptions = false
        return result
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
