import SwiftUI

struct WidgetData: Codable {
    var userName: String
    var points: Int
    var showPoints: Bool
    var showDate: Bool
    var lastUpdated: Date
    var homeScreenItems: [HomeScreenItem]
    var homeScreenThemes: [HomeScreenTheme]
    var customWidgets: [CustomWidgetConfig]
    
    static let defaultData = WidgetData(
        userName: "ゲスト",
        points: 0,
        showPoints: true,
        showDate: true,
        lastUpdated: Date(),
        homeScreenItems: [],
        homeScreenThemes: [
            HomeScreenTheme(name: "ピンク", backgroundImageName: "bg_pink", isSelected: true),
            HomeScreenTheme(name: "ダーク", backgroundImageName: "bg_dark", isSelected: false),
            HomeScreenTheme(name: "ブルー", backgroundImageName: "bg_blue", isSelected: false)
        ],
        customWidgets: []
    )
}

struct HomeScreenItem: Identifiable, Codable {
    var id = UUID()
    var imageName: String
    var title: String
    var position: CGPoint
    var size: CGSize
    var isWidget: Bool
    var widgetType: WidgetType?
    var customWidgetId: UUID?
    
    enum WidgetType: String, Codable, CaseIterable {
        case calendar
        case clock
        case photo
        case music
        case custom
    }
}

struct HomeScreenTheme: Identifiable, Codable {
    var id = UUID()
    var name: String
    var backgroundImageName: String
    var isSelected: Bool
}

class WidgetDataService: ObservableObject {
    static let shared = WidgetDataService()
    private let userDefaults = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")!
    private let widgetDataKey = "widgetData"
    
    @Published private(set) var widgetData: WidgetData = .defaultData
    
    private init() {
        loadWidgetData()
    }
    
    func loadWidgetData() -> WidgetData {
        if let data = userDefaults.data(forKey: widgetDataKey),
           let widgetData = try? JSONDecoder().decode(WidgetData.self, from: data) {
            self.widgetData = widgetData
            return widgetData
        }
        return .defaultData
    }
    
    func saveWidgetData(_ widgetData: WidgetData) {
        if let data = try? JSONEncoder().encode(widgetData) {
            userDefaults.set(data, forKey: widgetDataKey)
            self.widgetData = widgetData
        }
    }
}

// CGPoint, CGSizeのCodable対応
extension CGPoint: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let x = try container.decode(Double.self)
        let y = try container.decode(Double.self)
        self.init(x: x, y: y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(x)
        try container.encode(y)
    }
}

extension CGSize: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let width = try container.decode(Double.self)
        let height = try container.decode(Double.self)
        self.init(width: width, height: height)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(width)
        try container.encode(height)
    }
}
