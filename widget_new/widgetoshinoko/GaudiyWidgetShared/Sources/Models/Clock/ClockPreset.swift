import Foundation
import GaudiyWidgetShared

public struct ClockPreset: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let style: ClockStyle
    public let size: WidgetSize
    public let imageUrl: String?
    public let textColor: String?
    public let fontSize: Double?
    public let showSeconds: Bool
    public let category: ClockCategory
    public let popularity: Int
    public let isPublic: Bool
    public let createdBy: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: UUID,
        title: String,
        description: String,
        style: ClockStyle,
        size: WidgetSize,
        imageUrl: String?,
        textColor: String?,
        fontSize: Double?,
        showSeconds: Bool,
        category: ClockCategory,
        popularity: Int = 0,
        isPublic: Bool = true,
        createdBy: String = "system",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.style = style
        self.size = size
        self.imageUrl = imageUrl
        self.textColor = textColor
        self.fontSize = fontSize
        self.showSeconds = showSeconds
        self.category = category
        self.popularity = popularity
        self.isPublic = isPublic
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public enum ClockCategory: String, Codable {
    case classic
    case modern
    case simple
    case stylish
}
