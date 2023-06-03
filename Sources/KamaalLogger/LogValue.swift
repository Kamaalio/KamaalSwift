//
//  LogValue.swift
//
//
//  Created by Kamaal M Farah on 03/06/2023.
//

import Foundation

@propertyWrapper
public class LogValue<Value> {
    private var value: Value
    private let description: String
    private let logger: KamaalLogger
    private let level: LogLevels

    public init(wrappedValue: Value, description: String, logger: KamaalLogger, level: LogLevels) {
        self.value = wrappedValue
        self.description = description
        self.logger = logger
        self.level = level

        log(.initialize)
    }

    public var wrappedValue: Value {
        get {
            log(.get)
            return value
        }
        set {
            log(.set)
            value = newValue
        }
    }

    private enum Events: String {
        case initialize
        case get
        case set

        var localized: String {
            switch self {
            case .initialize:
                return "Initialized"
            case .get:
                return "Accessing"
            case .set:
                return "Updating"
            }
        }
    }

    private func log(_ event: Events) {
        let message = "\(event.localized) '\(description)'; value='\(value)'"
        switch level {
        case .error:
            logger.error(message)
        case .warning:
            logger.warning(message)
        case .info:
            logger.info(message)
        case .debug:
            logger.debug(message)
        }
    }
}
