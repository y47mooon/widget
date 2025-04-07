import Foundation

public struct SavedWidget: Identifiable, Codable, Equatable {
    public let id: UUID
    public let presetId: String
    public let size: WidgetSize
    public let type: WidgetType
    public let configuration: WidgetConfiguration
    public let createdAt: Date
    
    public init(id: UUID = UUID(),
                presetId: String,
                size: WidgetSize,
                type: WidgetType,
                configuration: WidgetConfiguration,
                createdAt: Date = Date()) {
        self.id = id
        self.presetId = presetId
        self.size = size
        self.type = type
        self.configuration = configuration
        self.createdAt = createdAt
    }
    
    public static func == (lhs: SavedWidget, rhs: SavedWidget) -> Bool {
        return lhs.id == rhs.id
    }
}
