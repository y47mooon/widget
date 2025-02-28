import Foundation

struct WidgetData: Codable {
    var userName: String
    var points: Int
    var lastUpdated: Date
    
    static let defaultData = WidgetData(
        userName: "ゲスト",
        points: 0,
        lastUpdated: Date()
    )
} 