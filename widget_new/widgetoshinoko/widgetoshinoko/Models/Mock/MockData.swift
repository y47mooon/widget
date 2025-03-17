import Foundation

struct MockData {
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
        // 他のモックデータ
    ]
    
    static let templates: [TemplateItem] = [
        // テンプレートのモックデータ
    ]
}
