import Foundation
import GaudiyWidgetShared

// CategoryTypeプロトコルは共有モジュールから使用
public typealias CategoryType = GaudiyWidgetShared.CategoryType

// ウィジェット用カテゴリー
public typealias WidgetCategory = GaudiyWidgetShared.WidgetCategory

// テンプレート用カテゴリーは共有モジュールから使用
public typealias TemplateCategory = GaudiyWidgetShared.TemplateCategory

// GaudiyWidgetSharedからWidgetTemplateType型を使用
public typealias WidgetTemplateType = GaudiyWidgetShared.WidgetTemplateType

// WidgetTemplateTypeをCategoryTypeプロトコルに準拠させる
extension WidgetTemplateType: CategoryType {
    public static var allCases: [WidgetTemplateType] {
        return WidgetTemplateType.allCases
    }
}

// 壁紙用カテゴリー
enum WallpaperCategory: String, CaseIterable, CategoryType {
    case popular = "wallpaper_popular"
    case new = "wallpaper_new"
    case recommended = "wallpaper_recommended"
    case seasonal = "wallpaper_seasonal"
    case anime = "wallpaper_anime"
    case character = "wallpaper_character"
    
    var displayName: String {
        return self.rawValue.localized
    }
}

// ロック画面用カテゴリー
enum LockScreenCategory: String, CategoryType, CaseIterable {
    case popular = "lockscreen_popular"
    case stylish = "lockscreen_stylish"
    case simple = "lockscreen_simple"
    case ai = "lockscreen_ai"
    case ruby = "lockscreen_ruby"
    
    var displayName: String {
        return self.rawValue.localized
    }
}

// 動く壁紙用カテゴリー
enum MovingWallpaperCategory: String, CaseIterable, CategoryType {
    case popular = "movingwallpaper_popular"
    case new = "movingwallpaper_new"
    case recommended = "movingwallpaper_recommended"
    case ocean = "movingwallpaper_ocean"
    case nature = "movingwallpaper_nature"
    case abstract = "movingwallpaper_abstract"
    
    var displayName: String {
        return self.rawValue.localized
    }
}

// 作成タイプの定義
enum WidgetCreationType: String, CaseIterable, CategoryType {
    case widget = "category_widget"
    case icon = "category_icon"
    case template = "category_template"
    case lockScreen = "category_lockScreen"
    case liveWallpaper = "category_movingWallpaper"
    case cancel = "button_cancel"
    
    var displayName: String {
        return self.rawValue.localized
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

// WidgetTemplateTypeとWidgetTypeの変換ヘルパー
extension WidgetTemplateType {
    public var widgetType: WidgetType? {
        switch self {
        case .analogClock: return .analogClock
        case .digitalClock: return .digitalClock
        case .weather: return .weather
        case .calendar: return .calendar
        case .photo: return .photo
        case .clock: return nil // clock is a category, not a specific type
        }
    }
}

// Contentの種類を表す列挙型
public enum ContentCategory: String, Codable, CaseIterable, Identifiable {
    case popular = "popular"
    case icon = "icon"
    case widget = "widget"
    case template = "template"
    
    public var id: String { self.rawValue }
    
    public var displayName: String {
        switch self {
        case .popular: return "content_popular".localized
        case .icon: return "content_icon".localized
        case .widget: return "content_widget".localized
        case .template: return "content_template".localized
        }
    }
    
    // システムアイコン名
    public var iconName: String {
        switch self {
        case .popular: return "star.fill"
        case .icon: return "app.fill"
        case .widget: return "square.grid.2x2.fill"
        case .template: return "doc.fill"
        }
    }
}

// アイコンカテゴリ - CategoryTypeプロトコルに準拠
public enum IconCategory: String, Codable, CaseIterable, CategoryType {
    case popular = "popular"
    case newItems = "new_items"
    case social = "social"
    case utility = "utility"
    case game = "game"
    case finance = "finance"
    case lifestyle = "lifestyle"
    case entertainment = "entertainment"
    case health = "health"
    case education = "education"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .popular: return "icon_popular".localized
        case .newItems: return "icon_new".localized
        case .social: return "icon_social".localized
        case .utility: return "icon_utility".localized
        case .game: return "icon_game".localized
        case .finance: return "icon_finance".localized
        case .lifestyle: return "icon_lifestyle".localized
        case .entertainment: return "icon_entertainment".localized
        case .health: return "icon_health".localized
        case .education: return "icon_education".localized
        case .other: return "icon_other".localized
        }
    }
}

// ダウンロードアクションタイプ
public enum DownloadActionType: String, Codable, CaseIterable {
    case icon = "icon"
    case widget = "widget"
    case template = "template"
    case lockScreen = "lock_screen"
    case liveWallpaper = "live_wallpaper"
    case cancel = "cancel"
    
    public var displayName: String {
        switch self {
        case .icon: return "action_icon".localized
        case .widget: return "action_widget".localized
        case .template: return "action_template".localized
        case .lockScreen: return "action_lock_screen".localized
        case .liveWallpaper: return "action_live_wallpaper".localized
        case .cancel: return "action_cancel".localized
        }
    }
    
    public var iconName: String {
        switch self {
        case .icon: return "app.badge"
        case .widget: return "square.grid.2x2"
        case .template: return "doc.text"
        case .lockScreen: return "lock"
        case .liveWallpaper: return "photo.fill"
        case .cancel: return "xmark"
        }
    }
}

// 表示名などの拡張が必要な場合は拡張で対応
extension WidgetCategory {
    public var displayName: String {
        switch self {
        case .popular: return "widget_popular".localized
        case .weather: return "widget_weather".localized
        case .clock: return "widget_clock".localized
        case .calendar: return "widget_calendar".localized
        case .photo: return "widget_photo".localized
        case .reminder: return "widget_reminder".localized
        case .date: return "widget_date".localized
        case .anniversary: return "widget_anniversary".localized
        case .fortune: return "widget_fortune".localized
        case .memo: return "widget_memo".localized
        }
    }
}
