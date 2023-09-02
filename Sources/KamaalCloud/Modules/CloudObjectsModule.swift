//
//  CloudObjectsModule.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

public class CloudObjectsModule {
    private let accounts: CloudAccountsModule
    private let database: CKDatabase

    init(accounts: CloudAccountsModule, database: CKDatabase) {
        self.accounts = accounts
        self.database = database
    }

    public enum Errors: Error {
        case accountFailure(context: CloudAccountsModule.Errors)
        case fetchFailure(context: Error)
        case unknownFailure(context: Error?)
    }

    public func list(ofType objectType: String) async -> Result<[CKRecord], Errors> {
        await fetch(ofType: objectType, by: NSPredicate(value: true), limit: nil)
    }

    public func find(ofType objectType: String, by predicate: NSPredicate) async -> Result<CKRecord?, Errors> {
        await fetch(ofType: objectType, by: predicate, limit: 1)
            .map(\.first)
    }

    public func filter(ofType objectType: String,
                       by predicate: NSPredicate,
                       limit: Int? = nil) async -> Result<[CKRecord], Errors> {
        await fetch(ofType: objectType, by: predicate, limit: limit)
    }

    private func fetch(ofType objectType: String,
                       by predicate: NSPredicate,
                       limit: Int? = nil) async -> Result<[CKRecord], Errors> {
        await withCheckedContinuation { continuation in
            _fetch(ofType: objectType, by: predicate, limit: limit) { result in
                continuation.resume(returning: result)
            }
        }
    }

    private func _fetch(ofType objectType: String,
                        by predicate: NSPredicate,
                        limit: Int? = nil,
                        completion: @escaping (Result<[CKRecord], Errors>) -> Void) {
        accounts.getStatus { [weak self] result in
            guard let self else {
                completion(.failure(.unknownFailure(context: nil)))
                return
            }

            switch result {
            case let .failure(failure):
                completion(.failure(.accountFailure(context: failure)))
                return
            case .success: break
            }

            let query = CKQuery(recordType: objectType, predicate: predicate)
            let queryOperation = CKQueryOperation(query: query)
            if let limit {
                queryOperation.resultsLimit = limit
            }

            var fetchedRecords: [CKRecord] = []
            func fetchWithQueryOperation(_ operation: CKQueryOperation) {
                operation.recordMatchedBlock = { _, recordResult in
                    switch recordResult {
                    case let .failure(failure): completion(.failure(.fetchFailure(context: failure)))
                    case let .success(success): fetchedRecords = fetchedRecords.appended(success)
                    }
                }
                operation.queryResultBlock = { operationResult in
                    let cursor: CKQueryOperation.Cursor?
                    switch operationResult {
                    case let .failure(failure):
                        completion(.failure(.fetchFailure(context: failure)))
                        return
                    case let .success(success): cursor = success
                    }

                    if let cursor {
                        let cursorQueryOperation = CKQueryOperation(cursor: cursor)
                        fetchWithQueryOperation(cursorQueryOperation)
                        return
                    }

                    completion(.success(fetchedRecords))
                }
            }

            fetchWithQueryOperation(queryOperation)
            self.database.add(queryOperation)
        }
    }
}
