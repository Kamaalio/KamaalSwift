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

    init(accounts: CloudAccountsModule, database: CKDatabase) {
        self.accounts = accounts
        self.fetchService = FetchService(database: database)
    }

    public enum Errors: Error {
        case fetchFailure(context: FetchErrors)
        case accountFailure(context: CloudAccountsModule.Errors)
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
        switch statusResult {
        case let .failure(failure): return .failure(.accountFailure(context: failure))
        case .success: break
        }

        return await fetchService.fetch(ofType: objectType, by: predicate, limit: limit)
            .mapError { error in .fetchFailure(context: error) }
    }
}
