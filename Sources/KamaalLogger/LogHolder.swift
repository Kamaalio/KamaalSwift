//
//  LogHolder.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import Foundation
import KamaalStructures

/// A bounded log buffer. Entries are available as soon as a logging call returns.
public actor LogHolder {
    private let storage: Storage

    private final class Storage: @unchecked Sendable {
        // The lock protects the queue from synchronous writes and actor-isolated snapshots.
        private let lock = NSLock()
        private var items: Queue<HoldedLog>

        init(max: Int?) {
            self.items = .init(max: max)
        }

        var logs: [HoldedLog] {
            self.lock.withLock { self.items.array }
        }

        func append(_ log: HoldedLog) {
            self.lock.withLock {
                if let max = self.items.max, max <= 0 {
                    return
                }
                self.items.enqueue(log)
            }
        }
    }

    /// A nil limit retains all entries. A nonpositive limit disables buffering.
    public init(max: Int? = 100) {
        self.storage = Storage(max: max)
    }

    /// A snapshot in insertion order, from oldest to newest.
    public var logs: [HoldedLog] {
        self.storage.logs
    }

    nonisolated func addLog(_ log: HoldedLog) {
        self.storage.append(log)
    }

    /// Singleton of ``LogHolder`` to be used globally.
    public static let shared = LogHolder()
}

/// A captured diagnostic entry.
public struct HoldedLog: Hashable, Sendable {
    /// The label of the log.
    public let label: String
    /// The type of the log as ``LogTypes``.
    public let level: LogLevels
    /// The message that was logged.
    public let message: String
    /// The time the log has been logged.
    public let timestamp: Date
    private let recordedFields: [LogField]

    /// Memberwise initializer.
    /// - Parameters:
    ///   - label: The label of the log.
    ///   - level: The level of the log as ``LogLevels``.
    ///   - message: The message that was logged.
    ///   - timestamp: The time the log has been logged.
    public init(label: String, level: LogLevels, message: String, timestamp: Date) {
        self.init(label: label, level: level, message: message, timestamp: timestamp, fields: [])
    }

    init(label: String, level: LogLevels, message: String, timestamp: Date, fields: [LogField]) {
        self.label = label
        self.level = level
        self.message = message
        self.timestamp = timestamp
        self.recordedFields = fields
    }

    /// Returns public fields in their original order, including repeated names.
    /// Enable private access only in a trusted developer view.
    public func fields(includingPrivate: Bool = false) -> [LogField] {
        if includingPrivate {
            return self.recordedFields
        }
        return self.recordedFields.filter { $0.privacy == .public }
    }

    /// Returns visible JSON payloads in field order. When none are available, returns a
    /// single JSON object containing the original message under the `message` key.
    public func jsonObjects(includingPrivate: Bool = false) throws -> [Data] {
        let objects = self.fields(includingPrivate: includingPrivate).compactMap { field -> Data? in
            guard case let .json(data) = field.value else { return nil }
            return data
        }
        if objects.isEmpty {
            return try [LogField.encodeJSON(["message": self.message])]
        }
        return objects
    }
}
