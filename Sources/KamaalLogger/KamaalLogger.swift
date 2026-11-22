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
        self.error(message, fields: [])
    }

    public func error(_ message: String, fields: [LogField]) {
        self.log(message, level: .error, fields: fields)
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
        self.warning(message, fields: [])
    }

    public func warning(_ message: String, fields: [LogField]) {
        self.log(message, level: .warning, fields: fields)
    }

    /// Logs multiple warning messages as a single entry separated by `; `.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func warning(_ messages: String...) {
        self.warning(messages.joined(separator: "; "))
    }

    /// Logs an informational message.
    /// - Parameter message: The message to log.
    public func info(_ message: String) {
        self.info(message, fields: [])
    }

    public func info(_ message: String, fields: [LogField]) {
        self.log(message, level: .info, fields: fields)
    }

    /// Logs multiple informational messages as a single entry separated by `; `.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func info(_ messages: String...) {
        self.info(messages.joined(separator: "; "))
    }

    /// Logs a debug message. Only stored when the `DEBUG` compiler flag is enabled.
    /// - Parameter message: The message to log.
    public func debug(_ message: String) {
        self.debug(message, fields: [])
    }

    public func debug(_ message: String, fields: [LogField]) {
        #if DEBUG
        self.log(message, level: .debug, fields: fields)
        #endif
    }

    private func log(_ message: String, level: LogLevels, fields: [LogField]) {
        let entry = HoldedLog(
            label: self.label,
            level: level,
            message: message,
            timestamp: Date(),
            fields: fields,
        )
        let consoleFields = entry.fields().map { "\($0.name): \($0.value.displayText)" }
        let consoleMessage = ([message] + consoleFields).joined(separator: "\n")
        switch level {
        case .error: self.logger.error("\(consoleMessage)")
        case .warning: self.logger.warning("\(consoleMessage)")
        case .info: self.logger.info("\(consoleMessage)")
        case .debug: self.logger.debug("\(consoleMessage)")
        }

        self.holder.addLog(entry)
        if level == .error, self.failOnError {
            assertionFailure(message)
        }
    }
}
