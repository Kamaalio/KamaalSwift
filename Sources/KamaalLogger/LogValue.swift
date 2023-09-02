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

        self.log(.initialize)
    }

    public var wrappedValue: Value {
        get {
            self.log(.get)
            return self.value
        }
        set {
            self.log(.set)
            self.value = newValue
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
        let message = "\(event.localized) '\(self.description)'; value='\(self.value)'"
        switch self.level {
        case .error:
            self.logger.error(message)
        case .warning:
            self.logger.warning(message)
        case .info:
            self.logger.info(message)
        case .debug:
            self.logger.debug(message)
        }
    }
}
