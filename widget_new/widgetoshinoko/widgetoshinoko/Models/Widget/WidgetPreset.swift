import Foundation
import SwiftUI
import GaudiyWidgetShared

// モジュールスコープで明示的に定義
public struct WidgetPreset: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let type: WidgetType
    public let size: WidgetSize
    public let style: String
    public let imageUrl: String
    public let backgroundColor: String?
    public let requiresPurchase: Bool
    public var isPurchased: Bool
    private var widgetConfiguration: GaudiyWidgetShared.WidgetConfiguration?
    
    public var configuration: [String: Any] {
        get { widgetConfiguration?.toDictionary() ?? [:] }
    }
    
    public var templateType: WidgetTemplateType {
        return type == .analogClock || type == .digitalClock ? 
               (type == .analogClock ? .analogClock : .digitalClock) :
               (type == .weather ? .weather : .calendar)
    }
    
    // 既存のイニシャライザ
    public init(
        id: UUID,
        title: String,
        description: String,
        type: WidgetType,
        size: WidgetSize,
        style: String,
        imageUrl: String,
        backgroundColor: String?,
        requiresPurchase: Bool,
        isPurchased: Bool,
        configuration: [String: Any]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.size = size
        self.style = style
        self.imageUrl = imageUrl
        self.backgroundColor = backgroundColor
        self.requiresPurchase = requiresPurchase
        self.isPurchased = isPurchased
        self.widgetConfiguration = GaudiyWidgetShared.WidgetConfiguration(from: configuration)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(WidgetType.self, forKey: .type)
        size = try container.decode(WidgetSize.self, forKey: .size)
        style = try container.decode(String.self, forKey: .style)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        requiresPurchase = try container.decode(Bool.self, forKey: .requiresPurchase)
        isPurchased = try container.decode(Bool.self, forKey: .isPurchased)
        widgetConfiguration = try container.decodeIfPresent(GaudiyWidgetShared.WidgetConfiguration.self, forKey: .widgetConfiguration)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(size, forKey: .size)
        try container.encode(style, forKey: .style)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encode(requiresPurchase, forKey: .requiresPurchase)
        try container.encode(isPurchased, forKey: .isPurchased)
        try container.encodeIfPresent(widgetConfiguration, forKey: .widgetConfiguration)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, type, size, style, imageUrl
        case backgroundColor, requiresPurchase, isPurchased
        case widgetConfiguration
    }
    
    // ClockConfigurationを生成するヘルパーメソッド
    public func toClockConfiguration() -> GaudiyWidgetShared.ClockConfiguration {
        let style: ClockStyle = type == .analogClock ? .analog : .digital
        let textColor = (configuration["textColor"] as? String) ?? "#000000"
        let fontSize = (configuration["fontSize"] as? Double) ?? 14.0
        let showSeconds = (configuration["showSeconds"] as? Bool) ?? false
        
        return GaudiyWidgetShared.ClockConfiguration(
            style: style,
            imageUrl: imageUrl,
            size: size,
            showSeconds: showSeconds,
            fontSize: fontSize,
            textColor: textColor
        )
    }
    
    // WidgetItemに変換するメソッド
    public func toWidgetItem() -> WidgetItem {
        return WidgetItem(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl,
            category: type.displayName,
            isFavorite: false,
            popularity: 0,
            createdAt: Date()
        )
    }
}
