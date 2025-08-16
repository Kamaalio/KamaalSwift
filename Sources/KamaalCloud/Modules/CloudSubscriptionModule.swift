//
//  CloudSubscriptionModule.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

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
        case fetchFailure(context: Error?)
    }

    public func subscribeToChanges(ofType objectType: String) async -> Result<CKSubscription, Errors> {
        await self.subscribeToChanges(ofTypes: [objectType])
            .map(\.first!)
    }

    public func subscribeToChanges(ofTypes objectTypes: [String]) async -> Result<[CKSubscription], Errors> {
        await withCheckedContinuation { continuation in
            self.subscribeToChanges(ofTypes: objectTypes) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func fetchAllSubscriptions() async -> Result<[CKSubscription], Errors> {
        if self.fetchingSubscriptions {
            let subscriptions = await getFetchingSubscriptions()
            return .success(subscriptions)
        }

        return await self.withFetchingSubscriptions { [weak self] in
            guard let self else { return .failure(.fetchFailure(context: nil)) }

            let statusResult = await self.accounts.getStatus()
                .mapError { error in Errors.accountFailure(context: error) }
            switch statusResult {
            case let .failure(failure): return .failure(failure)
            case .success: break
            }

            let subscriptions: [CKSubscription]
            do {
                subscriptions = try await self.database.fetchAllSubscriptions()
            } catch {
                return .failure(.fetchFailure(context: error))
            }

            self.fetchedSubscriptions = subscriptions
            return .success(subscriptions)
        }
    }

    private func getFetchingSubscriptions() async -> [CKSubscription] {
        await withCheckedContinuation { continuation in
            self.getFetchingSubscriptions { subscriptions in
                continuation.resume(returning: subscriptions)
            }
        }
    }

    private func subscribeToChanges(
        ofTypes objectTypes: [String],
        completion: @escaping (Result<[CKSubscription], Errors>) -> Void,
    ) {
        self.accounts.getStatus { [weak self] result in
            guard let self else { return }

            switch result {
            case let .failure(failure):
                completion(.failure(.accountFailure(context: failure)))
                return
            case .success: break
            }

            let subscriptionOptions: CKQuerySubscription.Options = [
                .firesOnRecordCreation,
                .firesOnRecordDeletion,
                .firesOnRecordUpdate,
            ]
            let predicate = NSPredicate(value: true)
            let subscriptionQuerys = objectTypes.map { objectType in
                let query = CKQuerySubscription(
                    recordType: objectType,
                    predicate: predicate,
                    subscriptionID: "\(objectType)-changes",
                    options: subscriptionOptions,
                )
                let notification = CKSubscription.NotificationInfo()
                notification.shouldSendContentAvailable = true
                query.notificationInfo = notification
                return query
            }

            let operation = CKModifySubscriptionsOperation(
                subscriptionsToSave: subscriptionQuerys,
                subscriptionIDsToDelete: nil,
            )
            var subscriptions: [CKSubscription] = []
            operation.modifySubscriptionsResultBlock = { operationResult in
                switch operationResult {
                case let .failure(failure): completion(.failure(.fetchFailure(context: failure)))
                case .success: break
                }

                var newSubscriptions = self.fetchedSubscriptions
                for subscription in subscriptions {
                    if let index = newSubscriptions.findIndex(by: \.subscriptionID, is: subscription.subscriptionID) {
                        newSubscriptions[index] = subscription
                    } else {
                        newSubscriptions = newSubscriptions.appended(subscription)
                    }
                }
                self.fetchedSubscriptions = newSubscriptions
                completion(.success(subscriptions))
            }
            operation.perSubscriptionSaveBlock = { _, saveResult in
                switch saveResult {
                case .failure: break
                case let .success(success): subscriptions = subscriptions.appended(success)
                }
            }
            operation.qualityOfService = .utility
            self.database.add(operation)
        }
    }

    private func getFetchingSubscriptions(completion: @escaping ([CKSubscription]) -> Void) {
        guard self.fetchingSubscriptions else {
            completion(self.fetchedSubscriptions)
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
            guard let self else { return }

            if !self.fetchingSubscriptions {
                timer.invalidate()
                completion(self.fetchedSubscriptions)
            }
        }
    }

    private func withFetchingSubscriptions<T>(completion: @escaping () async -> T) async -> T {
        self.fetchingSubscriptions = true
        let result = await completion()
        self.fetchingSubscriptions = false
        return result
    }
}

extension CKDatabase {
    fileprivate func fetchAllSubscriptions() async throws -> [CKSubscription] {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchAllSubscriptions { subscriptions, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: subscriptions ?? [])
            }
        }
    }
}
