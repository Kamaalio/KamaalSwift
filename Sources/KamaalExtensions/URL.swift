//
//  URL.swift
//
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import Foundation

extension URL {
    public init(staticString: StaticString) {
        self.init(string: "\(staticString)")!
    }

    public func decodeJSON<T: Codable>() -> Result<T, Error> {
        let data: Data
        do {
            data = try Data(contentsOf: self, options: .mappedIfSafe)
        } catch {
            return .failure(error)
        }
        let file: T
        do {
            file = try JSONDecoder().decode(T.self, from: data)
        } catch {
            return .failure(error)
        }
        return .success(file)
    }
}
