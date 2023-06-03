//
//  KamaalLogger.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import OSLog
import Foundation

/// Utility library to handle logging.
public struct KamaalLogger {
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
        failOnError: Bool = false
    ) {
        self.init(subsystem: subsystem, label: String(describing: type), holder: holder, failOnError: failOnError)
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
        failOnError: Bool = false
    ) {
        self.label = label
        self.logger = .init(subsystem: subsystem, category: label)
        self.holder = holder
        self.failOnError = failOnError
    }

    /// To log errors
    /// - Parameter message: The message to log.
    public func error(_ message: String) {
        logger.error("\(message)")
        addLogToQueue(type: .error, message: message)
        if failOnError {
            assertionFailure(message)
        }
    }

    /// To log errors formatted with an extra label.
    /// - Parameters:
    ///   - label: The label to show before the error.
    ///   - error: The error to log.
    public func error(label: String, error: Error) {
        let message = [label, "description='\(error.localizedDescription)'", "error='\(error)'"].joined(separator: "; ")
        self.error(message)
    }

    /// To log warnings.
    /// - Parameter message: The message to log.
    public func warning(_ message: String) {
        logger.warning("\(message)")
        addLogToQueue(type: .warning, message: message)
    }

    /// To log warnings.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func warning(_ messages: String...) {
        warning(messages.joined(separator: "; "))
    }

    /// To log information.
    /// - Parameter message: The message to log.
    public func info(_ message: String) {
        logger.info("\(message)")
        addLogToQueue(type: .info, message: message)
    }

    /// To log information.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func info(_ messages: String...) {
        info(messages.joined(separator: "; "))
    }

    /// To log debugging messages. Beaware of that logs only get stored when `DEBUG` compiler flag is turned on.
    /// - Parameter message: The message to log.
    public func debug(_ message: String) {
        logger.debug("\(message)")

        #if DEBUG
        addLogToQueue(type: .debug, message: message)
        #endif
    }

    private func addLogToQueue(type: HoldedLog.LogTypes, message: String) {
        Task {
            await holder.addLog(.init(label: label, type: type, message: message, timestamp: Date()))
        }
    }
}
