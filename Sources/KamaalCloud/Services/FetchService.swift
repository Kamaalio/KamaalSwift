//
//  FetchService.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

public enum FetchErrors: Error {
    case fetchFailure(context: Error)
}

class FetchService {
    private let database: CKDatabase

    init(database: CKDatabase) {
        self.database = database
    }

    func fetch(ofType objectType: String,
               by predicate: NSPredicate,
               limit: Int? = nil) async -> Result<[CKRecord], FetchErrors> {
        await withCheckedContinuation { continuation in
            self._fetch(ofType: objectType, by: predicate, limit: limit) { result in
                continuation.resume(returning: result)
            }
        }
    }

    private func _fetch(ofType objectType: String,
                        by predicate: NSPredicate,
                        limit: Int? = nil,
                        completion: @escaping (Result<[CKRecord], FetchErrors>) -> Void) {
        let query = CKQuery(recordType: objectType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        if let limit {
            queryOperation.resultsLimit = limit
        }

        var fetchedRecords: [CKRecord] = []
        func fetchWithQueryOperation(
            _ operation: CKQueryOperation,
            completion: @escaping (Result<[CKRecord], FetchErrors>) -> Void
        ) {
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
                    fetchWithQueryOperation(cursorQueryOperation, completion: completion)
                    return
                }

                completion(.success(fetchedRecords))
            }
        }

        fetchWithQueryOperation(queryOperation, completion: completion)
        self.database.add(queryOperation)
    }
}
