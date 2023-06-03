//
//  LogHolder.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import SwiftUI
import KamaalStructures

/// Actor class that holds all the logs.
public actor LogHolder {
    private var items: Queue<HoldedLog>

    /// Initializer.
    /// - Parameter max: Maximum amount of logs to hold.
    public init(max: Int? = 100) {
        self.items = .init(max: max)
    }

    /// Computed array of logs.
    public var logs: [HoldedLog] {
        items.array
    }

    func addLog(_ log: HoldedLog) {
        items.enqueue(log)
    }

    /// Singleton of ``LogHolder`` to be used globally.
    public static let shared = LogHolder()
}

/// An representation of a log.
public struct HoldedLog: Hashable {
    /// The label of the log.
    public let label: String
    /// The type of the log as ``LogTypes``.
    public let level: LogLevels
    /// The message that was logged.
    public let message: String
    /// The time the log has been logged.
    public let timestamp: Date

    /// Memberwise initializer.
    /// - Parameters:
    ///   - label: The label of the log.
    ///   - level: The level of the log as ``LogLevels``.
    ///   - message: The message that was logged.
    ///   - timestamp: The time the log has been logged.
    public init(label: String, level: LogLevels, message: String, timestamp: Date) {
        self.label = label
        self.level = level
        self.message = message
        self.timestamp = timestamp
    }
}
