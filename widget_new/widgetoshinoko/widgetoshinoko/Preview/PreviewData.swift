import Foundation

// プレビュー用のデータを提供する構造体
struct PreviewData {
    // 静的なプレビューデータを提供するプロパティ
    static let widgetItems: [WidgetItem] = (0..<10).map { index in
        WidgetItem(
            id: UUID(),
            title: "Preview Widget \(index + 1)",
            description: "プレビュー用の説明文です",
            imageUrl: "placeholder",
            category: WidgetCategory.popular.rawValue,
            popularity: 100,
            createdAt: Date()
        )
    }
    
    // その他のプレビューデータ
    static let mockWidgets = widgetItems
}

extension WidgetItem {
    static var preview: WidgetItem {
        MockData.widgets[0]
    }
    
    static var previewList: [WidgetItem] {
        MockData.widgets
    }
}

#if DEBUG
extension WidgetListViewModel {
    static var preview: WidgetListViewModel {
        let viewModel = WidgetListViewModel(
            repository: MockWidgetRepository(),
            category: .popular
        )
        return viewModel
    }
}
#endif
