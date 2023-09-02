//
//  CloudAccountsModule.swift
//
//
//  Created by Kamaal M Farah on 31/08/2023.
//

import CloudKit
import Foundation

public class KamaalCloud {
    public let accounts: CloudAccountsModule
    public let fetch: CloudFetchModule

    public init(containerID: String, databaseType: DatabaseType) {
        let container = CKContainer(identifier: containerID)
        let database: CKDatabase
        switch databaseType {
        case .public: database = container.publicCloudDatabase
        case .shared: database = container.sharedCloudDatabase
        case .private: database = container.privateCloudDatabase
        }
        let accounts = CloudAccountsModule(container: container)
        self.accounts = CloudAccountsModule(container: container)
        self.fetch = CloudFetchModule(accounts: accounts, database: database)
    }

    /// Access control of the container
    public enum DatabaseType {
        case `public`
        case shared
        case `private`
    }
}
