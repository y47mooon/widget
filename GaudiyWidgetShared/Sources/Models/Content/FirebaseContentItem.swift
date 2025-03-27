public struct FirebaseContentItem: Codable {
    public let id: String
    public let type: String
    public let contentType: String
    public let data: [String: AnyCodable]
    // 他のプロパティも同様にpublicに
    
    public init(id: String, type: String, contentType: String, data: [String: Any]) {
        self.id = id
        self.type = type
        self.contentType = contentType
        self.data = data.mapValues { AnyCodable($0) }
    }
}

// AnyCodableの実装
public struct AnyCodable: Codable {
    private let _value: Any
    
    public init(_ value: Any) {
        self._value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self._value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            self._value = bool
        } else if let int = try? container.decode(Int.self) {
            self._value = int
        } else if let double = try? container.decode(Double.self) {
            self._value = double
        } else if let string = try? container.decode(String.self) {
            self._value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self._value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self._value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch _value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(_value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded"))
        }
    }
    
    public var value: Any {
        return _value
    }
}
