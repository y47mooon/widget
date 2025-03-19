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
    case recommended = "おすすめ"
    case seasonal = "季節もの"
    case anime = "アニメ"
    case character = "キャラクター"
    
    var displayName: String {
        return self.rawValue
    }
}

// ロック画面用カテゴリー
enum LockScreenCategory: String, CategoryType, CaseIterable {
    case popular = "人気のロック画面"
    case stylish = "おしゃれ"
    case simple = "シンプル"
    case ai = "星野アイ"
    case ruby = "星野ルビー"
}

// 動く壁紙用カテゴリー
enum MovingWallpaperCategory: String, CaseIterable, CategoryType {
    case popular = "人気の動く壁紙"
    case new = "新着"
    case recommended = "おすすめ"
    case ocean = "海"
    case nature = "自然"
    case abstract = "抽象"
    
    var displayName: String {
        return self.rawValue
    }
}

// アイコン用カテゴリー
enum IconCategory: String, CaseIterable, CategoryType {
    case popular = "人気のアイコンセット"
    case new = "新着"
    case cute = "かわいい"
    case cool = "おしゃれ"
    case white = "白"
    case dark = "ダーク"
}
