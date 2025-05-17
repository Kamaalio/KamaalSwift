//
//  CloudAccountsModule.swift
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
    public func getStatus() async -> Result<Void, Errors> {
        await withCheckedContinuation { continuation in
            self.getStatus { result in
                continuation.resume(returning: result)
            }
        }
    }

    /// Fetch current users record id.
    /// - Returns: Returns the current users record id or a ``Errors`` on failure.
    public func fetchUserID() async -> Result<CKRecord.ID?, Errors> {
        let accountStatusResult = await getStatus()
        switch accountStatusResult {
        case let .failure(failure): return .failure(failure)
        case .success: break
        }

        let userID: CKRecord.ID?
        do {
            userID = try await self.container.userRecordID()
        } catch {
            return .failure(self.handleErrors(error))
        }

        return .success(userID)
    }

    func getStatus(completion: @escaping ((Result<Void, Errors>) -> Void)) {
        self.container.accountStatus { [weak self] status, error in
            guard let self else {
                completion(.failure(.unknownFailure(context: nil)))
                return
            }

            if let error {
                completion(.failure(self.handleErrors(error)))
                return
            }

            switch status {
            case .available: completion(.success(()))
            case .noAccount: completion(.failure(.noAccount))
            case .restricted: completion(.failure(.restrictedAccount))
            case .temporarilyUnavailable: completion(.failure(.temporarilyUnavailable))
            default: completion(.failure(.unknownFailure(context: nil)))
            }
        }
    }

    private func handleErrors(_ error: Error) -> Errors {
        if let error = error as? CKError {
            return self.handleCKError(error)
        }

        return .unknownFailure(context: error)
    }

    private func handleCKError(_ error: CKError) -> Errors {
        switch error.code {
        case .notAuthenticated: .unauthenticated
        case .networkFailure, .networkUnavailable: .networkFailure
        case .quotaExceeded: .quotaExceeded
        default: .unknownFailure(context: error)
        }
    }
}
