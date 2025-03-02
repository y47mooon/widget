import Foundation
import SwiftUI
import WidgetKit
import CoreGraphics

enum WidgetTheme: String, Codable, CaseIterable {
    case light
    case dark
    case pink
    case blue
    case purple
    
    var backgroundColor: Color {
        switch self {
        case .light: return Color(.systemBackground)
        case .dark: return Color(.systemGray6)
        case .pink: return Color(red: 255/255, green: 192/255, blue: 203/255)
        case .blue: return Color(red: 173/255, green: 216/255, blue: 230/255)
        case .purple: return Color(red: 221/255, green: 160/255, blue: 221/255)
        }
    }
    
    var textColor: Color {
        switch self {
        case .light, .pink, .blue, .purple: return .black
        case .dark: return .white
        }
    }
    
    var name: String {
        switch self {
        case .light: return "ライト"
        case .dark: return "ダーク"
        case .pink: return "ピンク"
        case .blue: return "ブルー"
        case .purple: return "パープル"
        }
    }
}

enum WidgetStyle: String, Codable, CaseIterable {
    case standard
    case minimal
    case fancy
    case calendar
    
    var name: String {
        switch self {
        case .standard: return "スタンダード"
        case .minimal: return "ミニマル"
        case .fancy: return "ファンシー"
        case .calendar: return "カレンダー"
        }
    }
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
    var textColor: String
    var isSelected: Bool
}

// カスタムウィジェット用のモデル
struct CustomWidgetConfig: Codable, Identifiable {
    var id = UUID()
    var name: String
    var backgroundColor: String // HEX形式の色コード
    var textColor: String // HEX形式の色コード
    var imageName: String?
    var text: String
    var fontSize: Double
    var showBorder: Bool
    var borderColor: String
    var cornerRadius: Double
    
    static let defaultConfig = CustomWidgetConfig(
        name: "マイウィジェット",
        backgroundColor: "#FFFFFF",
        textColor: "#000000",
        imageName: nil,
        text: "カスタムテキスト",
        fontSize: 16.0,
        showBorder: true,
        borderColor: "#CCCCCC",
        cornerRadius: 12.0
    )
}

struct WidgetData: Codable {
    var userName: String
    var points: Int
    var lastUpdated: Date
    var theme: WidgetTheme
    var style: WidgetStyle
    var showPoints: Bool
    var showDate: Bool
    var homeScreenItems: [HomeScreenItem]
    var homeScreenThemes: [HomeScreenTheme]
    var customWidgets: [CustomWidgetConfig]
    
    static let defaultData = WidgetData(
        userName: "ゲスト",
        points: 0,
        lastUpdated: Date(),
        theme: .light,
        style: .standard,
        showPoints: true,
        showDate: true,
        homeScreenItems: [],
        homeScreenThemes: [
            HomeScreenTheme(name: "ピンク", backgroundImageName: "bg_pink", textColor: "#000000", isSelected: true),
            HomeScreenTheme(name: "ダーク", backgroundImageName: "bg_dark", textColor: "#FFFFFF", isSelected: false),
            HomeScreenTheme(name: "ブルー", backgroundImageName: "bg_blue", textColor: "#000000", isSelected: false)
        ],
        customWidgets: [CustomWidgetConfig.defaultConfig]
    )
}

// データ共有サービス
class WidgetDataService {
    static let shared = WidgetDataService()
    private let userDefaults = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")
    
    private init() {}
    
    func saveWidgetData(_ data: WidgetData) {
        guard let encoded = try? JSONEncoder().encode(data),
              let userDefaults = userDefaults else {
            return
        }
        
        userDefaults.set(encoded, forKey: "widgetData")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func loadWidgetData() -> WidgetData {
        guard let userDefaults = userDefaults,
              let data = userDefaults.data(forKey: "widgetData"),
              let widgetData = try? JSONDecoder().decode(WidgetData.self, from: data) else {
            return WidgetData.defaultData
        }
        
        return widgetData
    }
    
    func addHomeScreenItem(_ item: HomeScreenItem, to data: inout WidgetData) {
        data.homeScreenItems.append(item)
        saveWidgetData(data)
    }
    
    func updateHomeScreenItem(_ item: HomeScreenItem, in data: inout WidgetData) {
        if let index = data.homeScreenItems.firstIndex(where: { $0.id == item.id }) {
            data.homeScreenItems[index] = item
            saveWidgetData(data)
        }
    }
    
    func removeHomeScreenItem(id: UUID, from data: inout WidgetData) {
        data.homeScreenItems.removeAll(where: { $0.id == id })
        saveWidgetData(data)
    }
    
    func selectTheme(id: UUID, in data: inout WidgetData) {
        for i in 0..<data.homeScreenThemes.count {
            data.homeScreenThemes[i].isSelected = (data.homeScreenThemes[i].id == id)
        }
        saveWidgetData(data)
    }
    
    func addCustomWidget(_ widget: CustomWidgetConfig, to data: inout WidgetData) {
        data.customWidgets.append(widget)
        saveWidgetData(data)
    }
    
    func updateCustomWidget(_ widget: CustomWidgetConfig, in data: inout WidgetData) {
        if let index = data.customWidgets.firstIndex(where: { $0.id == widget.id }) {
            data.customWidgets[index] = widget
            saveWidgetData(data)
        }
    }
    
    func removeCustomWidget(id: UUID, from data: inout WidgetData) {
        data.customWidgets.removeAll(where: { $0.id == id })
        saveWidgetData(data)
    }
} 