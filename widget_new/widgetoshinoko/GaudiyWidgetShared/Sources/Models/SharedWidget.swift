import Foundation
import WidgetKit

public struct SharedWidget: Codable {
    public let id: UUID
    public let presetId: String
    public let size: WidgetSize
    public let type: WidgetType
    public let configuration: WidgetConfiguration
    public let updatedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id, presetId, size, type, configuration, updatedAt
    }
    
    public init(from savedWidget: SavedWidget) {
        self.id = savedWidget.id
        self.presetId = savedWidget.presetId
        self.size = savedWidget.size
        self.type = savedWidget.type
        self.configuration = savedWidget.configuration
        self.updatedAt = Date()
    }
    
    public init(id: UUID, presetId: String, size: WidgetSize, type: WidgetType, configuration: WidgetConfiguration, updatedAt: Date = Date()) {
        self.id = id
        self.presetId = presetId
        self.size = size
        self.type = type
        self.configuration = configuration
        self.updatedAt = updatedAt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        presetId = try container.decode(String.self, forKey: .presetId)
        size = try container.decode(WidgetSize.self, forKey: .size)
        type = try container.decode(WidgetType.self, forKey: .type)
        configuration = try container.decode(WidgetConfiguration.self, forKey: .configuration)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(presetId, forKey: .presetId)
        try container.encode(size, forKey: .size)
        try container.encode(type, forKey: .type)
        try container.encode(configuration, forKey: .configuration)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

public class SharedWidgetManager {
    public static let shared = SharedWidgetManager()
    private let userDefaults: UserDefaults?
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.com.gaudiy.widget")
    }
    
    public func saveSharedWidgets(_ widgets: [SharedWidget]) {
        guard let encoded = try? JSONEncoder().encode(widgets) else { return }
        userDefaults?.set(encoded, forKey: "sharedWidgets")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    public func getSharedWidgets() -> [SharedWidget] {
        guard let data = userDefaults?.data(forKey: "sharedWidgets"),
              let widgets = try? JSONDecoder().decode([SharedWidget].self, from: data) else {
            return []
        }
        return widgets
    }
}
