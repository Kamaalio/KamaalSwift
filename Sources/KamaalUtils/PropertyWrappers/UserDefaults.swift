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
        get { self.container.object(forKey: constructKey(self.key)) as? Value }
        set { self.container.set(newValue, forKey: constructKey(self.key)) }
    }

    public var projectedValue: UserDefaultsValue<Value> { self }

    public func removeValue() {
        self.container.removeObject(forKey: constructKey(self.key))
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
        get { self.getValue() }
        set { self.setValue(newValue) }
    }

    public var projectedValue: UserDefaultsObject<Value> { self }

    public func removeValue() {
        self.container.removeObject(forKey: constructKey(self.key))
    }

    private func getValue() -> Value? {
        guard let data = container.object(forKey: constructKey(key)) as? Data else { return nil }

        return try? JSONDecoder().decode(Value.self, from: data)
    }

    private func setValue(_ newValue: Value?) {
        guard let newValue else {
            self.removeValue()
            return
        }

        guard let data = try? JSONEncoder().encode(newValue) else { return }

        self.container.set(data, forKey: constructKey(self.key))
    }
}

private func constructKey(_ key: String) -> String {
    "io.kamaal.KamaalUtils.UserDefaults.\(key)"
}
