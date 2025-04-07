import Foundation

public struct OshinokoWidget: Codable, Identifiable {
    public let id: UUID
    public let type: WidgetType
    public let size: WidgetSize
    public let configuration: WidgetConfiguration
    public let updatedAt: Date
    
    public init(id: UUID = UUID(), type: WidgetType, size: WidgetSize, configuration: WidgetConfiguration) {
        self.id = id
        self.type = type
        self.size = size
        self.configuration = configuration
        self.updatedAt = Date()
    }
}

