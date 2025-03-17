import Foundation

// 共通のカテゴリープロトコル
protocol CategoryType {
    var rawValue: String { get }
    static var allCases: [Self] { get }
}

// コンテンツタイプの定義
enum ContentType {
    case template
    case widget
    case wallpaper
    case lockScreen
    case movingWallpaper
}

// テンプレート用カテゴリー
enum TemplateCategory: String, CaseIterable, CategoryType {
    case popular = "人気のホーム画面"
    case new = "新着"
    case simple = "シンプル"
    case minimal = "ミニマル"
    case stylish = "おしゃれ"
}

// 壁紙用カテゴリー
enum WallpaperCategory: String, CaseIterable, CategoryType {
    case popular = "人気の壁紙"
    case new = "新着"
    case nature = "自然"
    case abstract = "抽象"
    case anime = "アニメ"
}

// ロック画面用カテゴリー
enum LockScreenCategory: String, CaseIterable, CategoryType {
    case popular = "人気のロック画面"
    case new = "新着"
    case clock = "時計"
    case weather = "天気"
    case calendar = "カレンダー"
}

// 動く壁紙用カテゴリー
enum MovingWallpaperCategory: String, CaseIterable, CategoryType {
    case popular = "人気の動く壁紙"
    case new = "新着"
    case nature = "自然"
    case abstract = "抽象"
    case anime = "アニメ"
}
