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
    private let fetchService: FetchService
    private let deleteService: DeleteService
    private let saveService: SaveService
    private let multipleOperationsService: MultipleOperationService

    init(accounts: CloudAccountsModule, database: CKDatabase) {
        self.accounts = accounts
        self.fetchService = FetchService(database: database)
        self.deleteService = DeleteService(database: database)
        self.saveService = SaveService(database: database)
        self.multipleOperationsService = MultipleOperationService(database: database)
    }

    public enum Errors: Error {
        case fetchFailure(context: FetchErrors)
        case accountFailure(context: CloudAccountsModule.Errors)
        case deleteFailure(context: Error)
        case saveFailure(context: Error)
        case multipleOperationsFailure(context: MultipleOperationErrors)
    }

    public func list(ofType objectType: String) async -> Result<[CKRecord], Errors> {
        let predicate = NSPredicate(value: true)
        return await filter(ofType: objectType, by: predicate, limit: nil)
    }

    public func find(ofType objectType: String, by predicate: NSPredicate) async -> Result<CKRecord?, Errors> {
        await filter(ofType: objectType, by: predicate, limit: 1)
            .map(\.first)
    }

    public func filter(ofType objectType: String,
                       by predicate: NSPredicate,
                       limit: Int? = nil) async -> Result<[CKRecord], Errors> {
        let statusResult = await accounts.getStatus()
            .mapError { error in Errors.accountFailure(context: error) }
        switch statusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        return await fetchService.fetch(ofType: objectType, by: predicate, limit: limit)
            .mapError { error in .fetchFailure(context: error) }
    }

    public func deleteAndSave(recordsToDelete: [CKRecord], recordsToSave: [CKRecord]) async -> Result<(
        recordsDeleted: [CKRecord.ID],
        recordsSaved: [CKRecord]
    ), Errors> {
        let statusResult = await accounts.getStatus()
            .mapError { error in Errors.accountFailure(context: error) }
        switch statusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        return await multipleOperationsService.execute(recordsToDelete: recordsToDelete, recordsToSave: recordsToSave)
            .mapError { error in .multipleOperationsFailure(context: error) }
    }

    public func delete(record: CKRecord) async -> Result<CKRecord.ID, Errors> {
        let statusResult = await accounts.getStatus()
            .mapError { error in Errors.accountFailure(context: error) }
        switch statusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        return await deleteService.delete(record)
            .mapError { error in .deleteFailure(context: error) }
    }

    public func delete(records: [CKRecord]) async -> Result<[CKRecord.ID], Errors> {
        await deleteAndSave(recordsToDelete: records, recordsToSave: [])
            .mapError { error in .deleteFailure(context: error) }
            .map(\.recordsDeleted)
    }

    public func save(record: CKRecord) async -> Result<CKRecord, Errors> {
        let statusResult = await accounts.getStatus()
            .mapError { error in Errors.accountFailure(context: error) }
        switch statusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        return await saveService.save(record: record)
            .mapError { error in .saveFailure(context: error) }
    }

    public func save(records: [CKRecord]) async -> Result<[CKRecord], Errors> {
        await deleteAndSave(recordsToDelete: [], recordsToSave: records)
            .mapError { error in .saveFailure(context: error) }
            .map(\.recordsSaved)
    }
}
