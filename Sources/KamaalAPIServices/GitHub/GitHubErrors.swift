//
//  GitHubErrors.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation
import KamaalNetworker

public enum GitHubErrors: Error, Equatable {
    case generalError(error: Error)
    case responseError(message: String, code: Int)
    case notAValidJSON
    case parsingError(error: Error)
    case invalidURL(url: String)

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }

    static func fromKamaalNetworker(_ error: KamaalNetworker.Errors) -> Self {
        switch error {
        case let .generalError(error: error): return .generalError(error: error)
        case let .responseError(message, code): return .responseError(message: message, code: code)
        case .notAValidJSON: return .notAValidJSON
        case let .parsingError(error: error): return .parsingError(error: error)
        case let .invalidURL(url: url): return .invalidURL(url: url)
        }
    }

    private var identifier: String {
        switch self {
        case let .generalError(error: error): return "general_error_\(error.localizedDescription)"
        case let .responseError(message, code): return "response_error_\(message)_\(code)"
        case .notAValidJSON: return "not_a_valid_json"
        case let .parsingError(error: error): return "parsing_error_\(error.localizedDescription)"
        case let .invalidURL(url: url): return "invalid_url_\(url)"
        }
    }
}
