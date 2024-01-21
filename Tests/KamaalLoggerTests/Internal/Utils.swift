//
//  Utils.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import Foundation
@testable import KamaalLogger
import KamaalExtensions

func getLog(from logger: KamaalLogger, at index: Int = 0) async throws -> HoldedLog {
    var log: HoldedLog?
    let timeoutDate = Date(timeIntervalSinceNow: 0.5)
    repeat {
        log = await logger.holder.logs.at(index)
    } while log == nil && Date().compare(timeoutDate) == .orderedAscending

    guard let log else {
        throw TestError.test
    }

    return log
}
