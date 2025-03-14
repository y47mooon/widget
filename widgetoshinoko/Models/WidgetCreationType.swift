import SwiftUI

enum WidgetCreationType: CaseIterable {
    case widget
    case icon
    case template
    case lockScreen
    case liveWallpaper
    case cancel
    
    var title: String {
        switch self {
        case .widget: return "ウィジェット"
        case .icon: return "アイコン"
        case .template: return "テンプレート"
        case .lockScreen: return "ロック画面"
        case .liveWallpaper: return "動く壁紙"
        case .cancel: return "閉じる"
        }
    }
    
    var iconName: String {
        switch self {
        case .widget: return "square.grid.2x2"
        case .icon: return "app.square"
        case .template: return "doc.text"
        case .lockScreen: return "lock"
        case .liveWallpaper: return "photo.fill"
        case .cancel: return "xmark"
        }
    }
}