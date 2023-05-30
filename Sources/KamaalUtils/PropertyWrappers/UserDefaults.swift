//
//  UserDefaults.swift
//
//
//  Created by Kamaal M Farah on 30/05/2023.
//

import Foundation

@propertyWrapper
public class UserDefaultsValue<Value> {
    public let key: String
    public let container: UserDefaults

    public init(key: String, container: UserDefaults = .standard) {
        self.key = key
        self.container = container
    }

    public var wrappedValue: Value? {
        get { container.object(forKey: constructKey(key)) as? Value }
        set { container.set(newValue, forKey: constructKey(key)) }
    }

    public var projectedValue: UserDefaultsValue<Value> { self }

    public func removeValue() {
        container.removeObject(forKey: constructKey(key))
    }
}

@propertyWrapper
public class UserDefaultsObject<Value: Codable> {
    public let key: String
    public let container: UserDefaults

    public init(key: String, container: UserDefaults = .standard) {
        self.key = key
        self.container = container
    }

    public var wrappedValue: Value? {
        get { getValue() }
        set { setValue(newValue) }
    }

    public var projectedValue: UserDefaultsObject<Value> { self }

    public func removeValue() {
        container.removeObject(forKey: constructKey(key))
    }

    private func getValue() -> Value? {
        guard let data = container.object(forKey: constructKey(key)) as? Data else { return nil }

        return try? JSONDecoder().decode(Value.self, from: data)
    }

    private func setValue(_ newValue: Value?) {
        guard let newValue else {
            removeValue()
            return
        }

        guard let data = try? JSONEncoder().encode(newValue) else { return }

        container.set(data, forKey: constructKey(key))
    }
}

private func constructKey(_ key: String) -> String {
    "io.kamaal.KamaalUtils.UserDefaults.\(key)"
}
