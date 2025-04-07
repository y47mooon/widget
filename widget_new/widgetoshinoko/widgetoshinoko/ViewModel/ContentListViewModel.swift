import Foundation
import GaudiyWidgetShared

@MainActor
final class ContentListViewModel: ObservableObject {
    @Published private(set) var contents: [Content] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: FirestoreRepositoryProtocol
    
    init(repository: FirestoreRepositoryProtocol = RepositoryFactory.shared.makeFirestoreRepository()) {
        self.repository = repository
    }
    
    func loadContents(category: String? = nil, limit: Int = 20) async {
        Logger.shared.info("Loading contents - category: \(category ?? "all")")
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseContents = try await repository.fetchContents(category: category ?? "", limit: limit)
            print("📦 Loaded \(firebaseContents.count) items from Firestore")
            contents = firebaseContents.compactMap { ContentAdapter.toContent($0) }
            print("🎯 Converted to \(contents.count) Content items")
        } catch {
            print("❌ Error loading contents: \(error)")
            errorMessage = "データの読み込みに失敗しました"
            Logger.shared.error("Error loading contents", error: error)
        }
        
        isLoading = false
    }
    
    func saveContent(_ content: Content) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseContent = ContentAdapter.toFirebaseContentItem(content)
            try await repository.saveContent(firebaseContent)
            await loadContents()
        } catch {
            errorMessage = "コンテンツの保存に失敗しました"
            print("Error: \(error)")
        }
        
        isLoading = false
    }
}
