import Foundation

/// A named diagnostic value that can be exposed independently of its entry.
public struct LogField: Hashable, Sendable {
    public enum Privacy: Hashable, Sendable {
        case `public`
        case `private`
    }

    public enum Value: Hashable, Sendable {
        case text(String)
        case json(Data)
        case encodingFailed

        /// A display representation of text or JSON.
        public var displayText: String {
            switch self {
            case let .text(text): text
            case let .json(data): String(decoding: data, as: UTF8.self)
            case .encodingFailed: "<JSON encoding failed>"
            }
        }
    }

    public let name: String
    public let value: Value
    public let privacy: Privacy

    /// Field names are diagnostic labels. Values default to private until explicitly approved.
    public init(_ name: String, _ value: String, privacy: Privacy = .private) {
        self.name = name
        self.value = .text(value)
        self.privacy = privacy
    }

    /// Encodes a value as sorted, pretty-printed JSON. On failure, the field contains only an encoding-failure marker.
    public init(_ name: String, object: some Encodable, privacy: Privacy = .private) {
        self.name = name
        self.value = (try? Self.encodeJSON(object)).map(Value.json) ?? .encodingFailed
        self.privacy = privacy
    }

    static func encodeJSON(_ object: some Encodable) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(object)
    }
}
