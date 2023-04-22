//
//  Acknowledgements.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import Foundation

public struct Acknowledgements: Hashable, Codable {
    public let packages: [Package]
    public let contributors: [Contributor]

    public init(packages: [Package], contributors: [Contributor]) {
        self.packages = packages
        self.contributors = contributors
    }

    public struct Package: Hashable, Codable {
        public let name: String
        public let url: URL
        public let author: String
        public let license: String?

        public init(name: String, url: URL, author: String, license: String?) {
            self.name = name
            self.url = url
            self.author = author
            self.license = license
        }
    }

    public struct Contributor: Hashable, Codable {
        public let name: String
        public let contributions: Int

        public init(name: String, contributions: Int) {
            self.name = name
            self.contributions = contributions
        }
    }
}
