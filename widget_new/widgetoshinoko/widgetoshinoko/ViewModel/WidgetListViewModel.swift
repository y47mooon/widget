import SwiftUI

@MainActor
final class WidgetListViewModel: ObservableObject {
    @Published private(set) var widgetItems: [WidgetItem] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    let category: WidgetCategory
    private let repository: WidgetRepositoryProtocol
    
    var filteredWidgets: [WidgetItem] {
        if searchText.isEmpty {
            return widgetItems
        }
        return widgetItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    nonisolated init(repository: WidgetRepositoryProtocol = MockWidgetRepository(),
         category: WidgetCategory) {
        self.repository = repository
        self.category = category
        // 非同期で初期データを読み込む
        Task { @MainActor in
            await self.loadWidgets()
        }
    }
    
    func loadWidgets() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            widgetItems = try await repository.fetchWidgets(category: category.rawValue)
        } catch let error as APIError {
            errorMessage = error.errorDescription
            #if DEBUG
            print("Error: \(error)")
            #endif
        } catch {
            errorMessage = "予期せぬエラーが発生しました"
        }
        
        isLoading = false
    }
    
    // ソート機能の実装
    func applySortOrder(_ order: SortOrder) {
        switch order {
        case .popular:
            widgetItems.sort { $0.popularity > $1.popularity }
        case .newest:
            widgetItems.sort { $0.createdAt > $1.createdAt }
        case .favorite:
            widgetItems.sort { $0.isFavorite && !$1.isFavorite }
        }
    }
    
    // プレビュー用
    static var previewViewModel: WidgetListViewModel {
        let viewModel = WidgetListViewModel(category: .popular)
        viewModel.widgetItems = PreviewData.widgetItems
        return viewModel
    }
}
