//
//  KamaalLogger.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import OSLog
import Foundation

/// Utility library to handle logging.
public struct KamaalLogger: Sendable {
    private let logger: Logger
    let label: String
    let holder: LogHolder
    let failOnError: Bool

    /// Initialize with type as label.
    /// - Parameters:
    ///   - subsystem: Subsystem search term for console.
    ///   - type: The type to name the label when logging.
    ///   - holder: Custom ``LogHolder``.
    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "",
        from type: (some Any).Type,
        holder: LogHolder = .shared,
        failOnError: Bool = false,
    ) {
        self.init(
            subsystem: subsystem, label: String(describing: type), holder: holder,
            failOnError: failOnError,
        )
    }

    /// Initialize with custom label.
    /// - Parameters:
    ///   - subsystem: Subsystem search term for console.
    ///   - label: The label to display when logging.
    ///   - holder: Custom ``LogHolder``.
    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "",
        label: String,
        holder: LogHolder = .shared,
        failOnError: Bool = false,
    ) {
        self.label = label
        self.logger = .init(subsystem: subsystem, category: label)
        self.holder = holder
        self.failOnError = failOnError
    }

    /// Logs an error message.
    /// - Parameter message: The message to log.
    public func error(_ message: String) {
        self.logger.error("\(message)")
        self.addLogToQueue(level: .error, message: message)
        if self.failOnError {
            assertionFailure(message)
        }
    }

    /// Logs an error with a label and Swift `Error`.
    /// - Parameters:
    ///   - label: The label to show before the error.
    ///   - error: The error to log.
    public func error(label: String, error: Error) {
        let message = [label, "description='\(error.localizedDescription)'", "error='\(error)'"]
            .joined(separator: "; ")
        self.error(message)
    }

    /// Logs a warning message.
    /// - Parameter message: The message to log.
    public func warning(_ message: String) {
        self.logger.warning("\(message)")
        self.addLogToQueue(level: .warning, message: message)
    }

    /// Logs multiple warning messages as a single entry separated by `; `.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func warning(_ messages: String...) {
        self.warning(messages.joined(separator: "; "))
    }

    /// Logs an informational message.
    /// - Parameter message: The message to log.
    public func info(_ message: String) {
        self.logger.info("\(message)")
        self.addLogToQueue(level: .info, message: message)
    }

    /// Logs multiple informational messages as a single entry separated by `; `.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func info(_ messages: String...) {
        self.info(messages.joined(separator: "; "))
    }

    /// Logs a debug message. Only stored when the `DEBUG` compiler flag is enabled.
    /// - Parameter message: The message to log.
    public func debug(_ message: String) {
        #if DEBUG
        self.logger.debug("\(message)")
        self.addLogToQueue(level: .debug, message: message)
        #endif
    }

    private func addLogToQueue(level: LogLevels, message: String) {
        Task {
            await self.holder.addLog(
                .init(label: self.label, level: level, message: message, timestamp: Date()),
            )
        }
    }
}
