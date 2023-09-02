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

    func delete(_ record: CKRecord) async -> Result<CKRecord.ID, DeleteErrors> {
        let deletedRecordID: CKRecord.ID
        do {
            deletedRecordID = try await self.database.deleteRecord(withID: record.recordID)
        } catch {
            return .failure(.deleteFailure(context: error))
        }
        return .success(deletedRecordID)
    }
}
