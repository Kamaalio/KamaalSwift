//
//  Task.swift
//
//
//  Created by Kamaal M Farah on 21/01/2024.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: TimeInterval) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
