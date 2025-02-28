import Foundation
import SwiftUI

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

struct WidgetData: Codable {
    var userName: String
    var points: Int
    var lastUpdated: Date
    var theme: WidgetTheme
    var style: WidgetStyle
    var showPoints: Bool
    var showDate: Bool
    
    static let defaultData = WidgetData(
        userName: "ゲスト",
        points: 0,
        lastUpdated: Date(),
        theme: .light,
        style: .standard,
        showPoints: true,
        showDate: true
    )
} 