//
//  Errors.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import Foundation

enum TestError: LocalizedError {
    case test

    public var errorDescription: String? {
        "something horrible happened"
    }
}
