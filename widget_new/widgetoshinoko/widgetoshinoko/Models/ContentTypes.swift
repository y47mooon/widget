import Foundation

// 共通のカテゴリープロトコル
protocol CategoryType {
    var rawValue: String { get }
    static var allCases: [Self] { get }
    var displayName: String { get }
}

// コンテンツタイプの定義
enum ContentType {
    case template
    case widget
    case wallpaper
    case lockScreen
    case movingWallpaper
}

// ウィジェット用カテゴリー
enum WidgetCategory: String, CaseIterable, CategoryType {
    case popular = "widget_popular"
    case weather = "widget_weather"
    case clock = "widget_clock"
    case calendar = "widget_calendar"
    case reminder = "widget_reminder"
    case date = "widget_date"
    case anniversary = "widget_anniversary"
    case fortune = "widget_fortune"
    case memo = "widget_memo"
    
    var displayName: String {
        return self.rawValue.localized
    }
}

// テンプレート用カテゴリー
enum TemplateCategory: String, CaseIterable, CategoryType {
    case popular = "template_popular"
    case new = "template_new"
    case simple = "template_simple"
    case minimal = "template_minimal"
    case stylish = "template_stylish"
    
    var displayName: String {
        return self.rawValue.localized
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

// アイコン用カテゴリー
enum IconCategory: String, CaseIterable, CategoryType {
    case popular = "icon_popular"
    case new = "icon_new"
    case cute = "icon_cute"
    case cool = "icon_cool"
    case white = "icon_white"
    case dark = "icon_dark"
    
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

enum WidgetSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var displayName: String {
        return self.rawValue
    }
}
