import SwiftUI
import GaudiyWidgetShared
import WidgetKit


public struct WidgetLayoutManager {
    // サイズごとのレイアウト設定を一元管理
    public static func getFontSize(for size: WidgetSize, configuration: ClockConfiguration) -> CGFloat {
        // ユーザー設定があれば優先
        if configuration.fontSize > 0 {
            return configuration.fontSize
        }
        
        // デフォルト値
        switch size {
        case .small:
            return 14
        case .medium:
            return 20
        case .large:
            return 28
        }
    }
    
    public static func getTextAlignment(for size: WidgetSize) -> Alignment {
        switch size {
        case .small:
            return .center
        case .medium, .large:
            return .leading
        }
    }
    
    public static func getPadding(for size: WidgetSize) -> EdgeInsets {
        switch size {
        case .small:
            return EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        case .medium:
            return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        case .large:
            return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        }
    }
    
    public static func getWidgetSize(for family: WidgetFamily) -> WidgetSize {
        switch family {
        case .systemSmall: return .small
        case .systemMedium: return .medium
        case .systemLarge: return .large
        case .systemExtraLarge: return .large
        @unknown default: return .medium
        }
    }
}
