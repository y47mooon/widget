import Foundation
import GaudiyWidgetShared

// GaudiyContentTypeの拡張機能
extension GaudiyContentType {
    /// すべてのケースを配列で返す
    public static var allCases: [GaudiyContentType] {
        return [.widget, .wallpaper, .lockScreen, .icon, .template, .movingWallpaper]
    }
    
    /// コンテンツタイプに応じたアイコン名を返す
    var iconName: String {
        switch self {
        case .widget: return "square.grid.2x2"
        case .wallpaper: return "photo"
        case .lockScreen: return "lock.shield"
        case .icon: return "app"
        case .template: return "doc.text.image"
        case .movingWallpaper: return "video"
        }
    }
} 