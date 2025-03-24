import Foundation

@MainActor
final class ContentListViewModel<Category: CategoryType>: ObservableObject {
    @Published private(set) var items: [ContentItem<Category>] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: ContentRepositoryProtocol
    let category: Category
    
    init(repository: ContentRepositoryProtocol = MockContentRepository(), category: Category) {
        self.repository = repository
        self.category = category
    }
    
    func loadItems(limit: Int = 5) async {
        isLoading = true
        errorMessage = nil
        
        do {
            items = try await repository.fetchItems(category: category, limit: limit)
        } catch {
            errorMessage = "データの読み込みに失敗しました"
        }
        
        isLoading = false
    }
}
