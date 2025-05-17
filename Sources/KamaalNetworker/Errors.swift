//
//  Errors.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import Foundation

extension KamaalNetworker {
    public enum Errors: Error {
        case generalError(error: Error)
        case responseError(message: String, code: Int)
        case notAValidJSON
        case parsingError(error: Error)
        case invalidURL(url: String)

        private var identifier: String {
            switch self {
            case let .generalError(error: error): "general_error_\(error.localizedDescription)"
            case let .responseError(message: message, code: code): "response_error_\(message)_\(code)"
            case .notAValidJSON: "not_a_valid_json"
            case let .parsingError(error: error): "parsing_error_\(error.localizedDescription)"
            case let .invalidURL(url: url): "invalid_url_\(url)"
            }
        }
    }
}

extension KamaalNetworker.Errors: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
