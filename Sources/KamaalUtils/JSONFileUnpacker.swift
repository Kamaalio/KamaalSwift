//
//  JSONFileUnpacker.swift
//
//
//  Created by Kamaal M Farah on 30/05/2023.
//

import Foundation

public enum JSONFileUnpackerErrors: Error {
    case fileNotFound
    case cannotReadData(context: Error)
    case decodingFailure(context: Error)
}

extension JSONFileUnpackerErrors: Equatable {
    public static func == (lhs: JSONFileUnpackerErrors, rhs: JSONFileUnpackerErrors) -> Bool {
        lhs.stringValue == rhs.stringValue
    }

    private var stringValue: String {
        switch self {
        case .fileNotFound:
            return "file_not_found"
        case let .cannotReadData(context):
            return "cannot_read_data_\(context)"
        case let .decodingFailure(context):
            return "decoding_failure_\(context)"
        }
    }
}

public class JSONFileUnpacker<Content: Decodable> {
    public private(set) var content: Content

    public init(filename: String, ofType fileType: String = "json", bundle: Bundle = Bundle.main) throws {
        guard let path = bundle.path(forResource: filename, ofType: fileType)
        else { throw JSONFileUnpackerErrors.fileNotFound }

        let url = URL(fileURLWithPath: path)
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONFileUnpackerErrors.cannotReadData(context: error)
        }

        let content: Content
        do {
            content = try JSONDecoder().decode(Content.self, from: data)
        } catch {
            throw JSONFileUnpackerErrors.decodingFailure(context: error)
        }

        self.content = content
    }
}
