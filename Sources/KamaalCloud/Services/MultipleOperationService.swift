//
//  MultipleOperationService.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

public enum MultipleOperationErrors: Error {
    case multipleOperationsFailure(context: Error)
}

class MultipleOperationService {
    private let database: CKDatabase

    init(database: CKDatabase) {
        self.database = database
    }

    func execute(recordsToDelete: [CKRecord], recordsToSave: [CKRecord]) async -> Result<(
        recordsDeleted: [CKRecord.ID],
        recordsSaved: [CKRecord]
    ), MultipleOperationErrors> {
        await withCheckedContinuation { continuation in
            self.execute(recordsToDelete: recordsToDelete, recordsToSave: recordsToSave, completion: { result in
                continuation.resume(returning: result)
            })
        }
    }

    private func execute(
        recordsToDelete: [CKRecord],
        recordsToSave: [CKRecord],
        completion: @escaping ((Result<
            (recordsDeleted: [CKRecord.ID], recordsSaved: [CKRecord]),
            MultipleOperationErrors
        >) -> Void),
    ) {
        let hasRecordsToOperateOn = !recordsToSave.concat(recordsToDelete).isEmpty
        guard hasRecordsToOperateOn else {
            completion(.success(([], [])))
            return
        }

        let recordsToDeleteIDs = recordsToDelete.map(\.recordID)
        let modification = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordsToDeleteIDs)
        modification.database = self.database
        let queue = OperationQueue()
        queue.addOperations([modification], waitUntilFinished: false)
        modification.modifyRecordsResultBlock = { operationResult in
            switch operationResult {
            case let .failure(failure):
                completion(.failure(.multipleOperationsFailure(context: failure)))
                return
            case .success: break
            }

            completion(.success((recordsToDeleteIDs, recordsToSave)))
        }
    }
}
