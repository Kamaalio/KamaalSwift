//
//  Utils.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

@testable import KamaalLogger
import KamaalExtensions

func getLog(from logger: KamaalLogger, at index: Int = 0) async throws -> HoldedLog {
    guard let log = await logger.holder.logs.at(index) else {
        throw TestError.test
    }

    return log
}
