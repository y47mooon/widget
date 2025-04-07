import Foundation
import GaudiyWidgetShared

// モックデータを提供するユーティリティクラス
// 注意: このクラスは移行期間のみ使用し、データベースによる実装に完全に移行後は削除する予定
struct MockData {
    // モックウィジェットアイテム
    static let widgets: [WidgetItem] = [
        WidgetItem(
            id: UUID(),
            title: "シンプル時計",
            description: "モダンでシンプルな時計ウィジェット",
            imageUrl: "mock_clock",
            category: "時計",
            isFavorite: false,
            popularity: 100,
            createdAt: Date().addingTimeInterval(-86400) // 1日前
        ),
        WidgetItem(
            id: UUID(),
            title: "天気予報",
            description: "天気予報ウィジェット",
            imageUrl: "mock_weather",
            category: "天気",
            isFavorite: true,
            popularity: 150,
            createdAt: Date() // 現在
        ),
        WidgetItem(
            id: UUID(),
            title: "カレンダー",
            description: "シンプルなカレンダーウィジェット",
            imageUrl: "mock_calendar",
            category: "カレンダー",
            isFavorite: false,
            popularity: 120,
            createdAt: Date()
        )
    ]
    
    // モックテンプレートアイテム
    static let templates: [TemplateItem] = [
        TemplateItem(
            id: UUID(),
            title: "シンプルモダン",
            description: "シンプルで使いやすいテンプレート",
            imageUrl: "",
            category: GaudiyWidgetShared.TemplateCategory.simple,
            popularity: 850
        ),
        TemplateItem(
            id: UUID(),
            title: "スタイリッシュポップ",
            description: "鮮やかな色使いのテンプレート",
            imageUrl: "",
            category: GaudiyWidgetShared.TemplateCategory.stylish,
            popularity: 720
        )
    ]
}
