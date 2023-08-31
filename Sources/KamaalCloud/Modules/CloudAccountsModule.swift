//
//  KamaalCloud+account.swift
//
//
//  Created by Kamaal M Farah on 31/08/2023.
//

import CloudKit
import Foundation

public class CloudAccountsModule {
    private let container: CKContainer

    init(container: CKContainer) {
        self.container = container
    }

    public enum Errors: Error {
        case unauthenticated
        case networkFailure
        case quotaExceeded
        case unknownFailure(context: Error?)
        case noAccount
        case restrictedAccount
        case temporarilyUnavailable
    }

    /// Get account status.
    /// - Returns: A result that is either `Void` on success or ``Errors`` on failure.
    public func getAccountStatus() async -> Result<Void, Errors> {
        let status: CKAccountStatus
        do {
            status = try await container.accountStatus()
        } catch {
            if let error = error as? CKError {
                return .failure(handleCKError(error))
            }
            return .failure(.unknownFailure(context: error))
        }

        switch status {
        case .available: return .success(())
        case .noAccount: return .failure(.noAccount)
        case .restricted: return .failure(.restrictedAccount)
        case .temporarilyUnavailable: return .failure(.temporarilyUnavailable)
        default: return .failure(.unknownFailure(context: nil))
        }
    }

    /// Fetch current users record id.
    /// - Returns: Returns the current users record id or a ``Errors`` on failure.
    public func fetchUserID() async -> Result<CKRecord.ID?, Errors> {
        let accountStatusResult = await getAccountStatus()
        switch accountStatusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        let userID: CKRecord.ID?
        do {
            userID = try await container.userRecordID()
        } catch {
            if let error = error as? CKError {
                return .failure(handleCKError(error))
            }
            return .failure(.unknownFailure(context: error))
        }

        return .success(userID)
    }

    private func handleCKError(_ error: CKError) -> Errors {
        switch error.code {
        case .notAuthenticated: return .unauthenticated
        case .networkFailure, .networkUnavailable: return .networkFailure
        case .quotaExceeded: return .quotaExceeded
        default: return .unknownFailure(context: error)
        }
    }
}
