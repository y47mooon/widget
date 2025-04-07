import Foundation
import GaudiyWidgetShared

// 共通のカテゴリープロトコル
public protocol CategoryType {
    var rawValue: String { get }
    static var allCases: [Self] { get }
    var displayName: String { get }
}

// GaudiyContentTypeの定義を削除（別ファイルに移動済み）

// ウィジェット用カテゴリー
public typealias WidgetCategory = GaudiyWidgetShared.WidgetCategory

// テンプレート用カテゴリー
// GaudiyWidgetSharedで定義済みの型を使用するためコメントアウト
//enum TemplateCategory: String, CaseIterable, CategoryType {
//    case popular = "template_popular"
//    case new = "template_new"
//    case recommended = "template_recommended"
//    case seasonal = "template_seasonal"
//    case simple = "template_simple"
//    case minimal = "template_minimal"
//    case stylish = "template_stylish"
//    
//    var displayName: String {
//        return self.rawValue.localized
//    }
//}

// GaudiyWidgetSharedからTemplateCategory型を使用
public typealias TemplateCategory = GaudiyWidgetShared.TemplateCategory

// GaudiyWidgetSharedパッケージのTemplateCategoryをCategoryTypeに明示的に準拠させる
extension GaudiyWidgetShared.TemplateCategory: CategoryType {}

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

// WidgetTemplateTypeの追加（既存のものがない場合）
public enum WidgetTemplateType: String, Codable, CaseIterable {
    case analogClock = "analog_clock"
    case digitalClock = "digital_clock"
    case weather = "weather"
    case calendar = "calendar"
    case photo = "photo"
    
    public var displayName: String {
        switch self {
        case .analogClock: return "アナログ時計"
        case .digitalClock: return "デジタル時計"
        case .weather: return "天気"
        case .calendar: return "カレンダー"
        case .photo: return "写真"
        }
    }
    
    // WidgetTypeとの変換（必要に応じて）
    public var widgetType: WidgetType {
        switch self {
        case .analogClock: return .analogClock
        case .digitalClock: return .digitalClock
        case .weather: return .weather
        case .calendar: return .calendar
        case .photo: return .photo
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
