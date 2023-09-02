//
//  DeleteService.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation

public enum DeleteErrors: Error {
    case deleteFailure(context: Error)
}

class DeleteService {
    private let database: CKDatabase

    init(database: CKDatabase) {
        self.database = database
    }

    func delete(_ record: CKRecord) async -> Result<Void, DeleteErrors> {
        do {
            try await database.deleteRecord(withID: record.recordID)
        } catch {
            return .failure(.deleteFailure(context: error))
        }
        return .success(())
    }

    func deleteMultiple(_ records: [CKRecord]) async -> Result<Void, DeleteErrors> {
        await withCheckedContinuation { continuation in
            deleteMultiple(records) { result in
                continuation.resume(returning: result)
            }
        }
    }

    private func deleteMultiple(_ records: [CKRecord], completion: @escaping ((Result<Void, DeleteErrors>) -> Void)) {
        guard !records.isEmpty else {
            completion(.success(()))
            return
        }

        let modification = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: records.map(\.recordID))
        modification.database = database
        let queue = OperationQueue()
        queue.addOperations([modification], waitUntilFinished: false)
        modification.modifyRecordsResultBlock = { operationResult in
            switch operationResult {
            case let .failure(failure): completion(.failure(.deleteFailure(context: failure)))
            case .success: completion(.success(()))
            }
        }
    }
}
