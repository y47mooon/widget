import Foundation
import GaudiyWidgetShared

public struct ClockConfiguration: Codable, Equatable {
    public let style: ClockStyle
    public let imageUrl: String
    public let size: WidgetSize
    public let showSeconds: Bool
    public let fontSize: Double
    public let textColor: String
    
    public init(
        style: ClockStyle,
        imageUrl: String, 
        size: WidgetSize,
        showSeconds: Bool = false,
        fontSize: Double = 14.0,
        textColor: String = "#000000"
    ) {
        self.style = style
        self.imageUrl = imageUrl
        self.size = size
        self.showSeconds = showSeconds
        self.fontSize = fontSize
        self.textColor = textColor
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        style = try container.decode(ClockStyle.self, forKey: .style)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        size = try container.decode(WidgetSize.self, forKey: .size)
        showSeconds = try container.decode(Bool.self, forKey: .showSeconds)
        fontSize = try container.decode(Double.self, forKey: .fontSize)
        textColor = try container.decode(String.self, forKey: .textColor)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(style, forKey: .style)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(size, forKey: .size)
        try container.encode(showSeconds, forKey: .showSeconds)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(textColor, forKey: .textColor)
    }
    
    private enum CodingKeys: String, CodingKey {
        case style
        case imageUrl
        case size
        case showSeconds
        case fontSize
        case textColor
    }
    
    public static func == (lhs: ClockConfiguration, rhs: ClockConfiguration) -> Bool {
        return lhs.style == rhs.style &&
               lhs.imageUrl == rhs.imageUrl &&
               lhs.size == rhs.size &&
               lhs.showSeconds == rhs.showSeconds &&
               lhs.fontSize == rhs.fontSize &&
               lhs.textColor == rhs.textColor
    }
}
