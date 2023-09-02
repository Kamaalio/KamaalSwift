//
//  SaveService.swift
//
//
//  Created by Kamaal M Farah on 02/09/2023.
//

import CloudKit
import Foundation

public enum SaveErrors: Error {
    case saveFailure(context: Error)
}

class SaveService {
    private let database: CKDatabase

    init(database: CKDatabase) {
        self.database = database
    }

    func save(record: CKRecord) async -> Result<CKRecord, SaveErrors> {
        let updatedRecord: CKRecord
        do {
            updatedRecord = try await self.database.save(record)
        } catch {
            return .failure(.saveFailure(context: error))
        }
        return .success(updatedRecord)
    }
}
