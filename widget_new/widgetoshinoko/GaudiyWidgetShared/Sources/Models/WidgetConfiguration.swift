import Foundation

public struct WidgetConfiguration: Codable {
    public var textColor: String?
    public var fontSize: Double?
    public var showSeconds: Bool?
    public var otherProperties: [String: String]?
    
    public init(textColor: String? = nil, 
                fontSize: Double? = nil, 
                showSeconds: Bool? = nil, 
                otherProperties: [String: String]? = nil) {
        self.textColor = textColor
        self.fontSize = fontSize
        self.showSeconds = showSeconds
        self.otherProperties = otherProperties
    }
    
    public init(from dictionary: [String: Any]) {
        self.textColor = dictionary["textColor"] as? String
        self.fontSize = dictionary["fontSize"] as? Double
        self.showSeconds = dictionary["showSeconds"] as? Bool
        
        var other: [String: String] = [:]
        for (key, value) in dictionary {
            if !["textColor", "fontSize", "showSeconds"].contains(key),
               let stringValue = String(describing: value) as? String {
                other[key] = stringValue
            }
        }
        self.otherProperties = other
    }
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let textColor = textColor { dict["textColor"] = textColor }
        if let fontSize = fontSize { dict["fontSize"] = fontSize }
        if let showSeconds = showSeconds { dict["showSeconds"] = showSeconds }
        if let other = otherProperties { dict.merge(other) { (_, new) in new } }
        return dict
    }
}