//
//  KamaalCloud.swift
//
//
//  Created by Kamaal M Farah on 31/08/2023.
//

import CloudKit
import Foundation

public class KamaalCloud {
    public let objects: CloudObjectsModule
    public let subscriptions: CloudSubscriptionModule

    public init(containerID: String, databaseType: DatabaseType) {
        let container = CKContainer(identifier: containerID)
        let database: CKDatabase = switch databaseType {
        case .public: container.publicCloudDatabase
        case .shared: container.sharedCloudDatabase
        case .private: container.privateCloudDatabase
        }
        let accounts = CloudAccountsModule(container: container)
        self.objects = CloudObjectsModule(accounts: accounts, database: database)
        self.subscriptions = CloudSubscriptionModule(accounts: accounts, database: database)
    }

    /// Access control of the container
    public enum DatabaseType {
        case `public`
        case shared
        case `private`
    }
}
