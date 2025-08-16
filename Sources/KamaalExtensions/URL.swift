//
//  URL.swift
//
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import Foundation

extension URL {
    /// Initializes a URL from a compile-time `StaticString`.
    public init(staticString: StaticString) {
        self.init(string: "\(staticString)")!
    }

    /// Reads the file or resource at the URL and decodes JSON into `T`.
    /// - Returns: `.success(T)` when decoding succeeds, otherwise `.failure(Error)`.
    ///
    /// # Example
    /// ```swift
    /// let url = Bundle.main.url(forResource: "config", withExtension: "json")!
    /// let result: Result<MyConfig, Error> = url.decodeJSON()
    /// ```
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
