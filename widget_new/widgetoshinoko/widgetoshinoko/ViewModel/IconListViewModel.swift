import SwiftUI      // ObservableObjectのために必要
import Combine      // @Publishedのために必要

protocol IconListViewModelProtocol: ObservableObject {
    associatedtype Item
    var items: [Item] { get }
    var isLoading: Bool { get }
    var hasMoreItems: Bool { get }
    func loadMoreItems() async
    func loadInitialItems() async
}

class IconListViewModel: IconListViewModelProtocol {
    @Published private(set) var items: [IconSet] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMoreItems = true
    
    private let category: IconCategory
    private var currentPage = 0
    
    init(category: IconCategory) {
        self.category = category
    }
    
    func loadMoreItems() async {
        guard !isLoading, hasMoreItems else { return }
        
        await MainActor.run { isLoading = true }
        
        // TODO: 実際のAPI呼び出しに置き換え
        // 仮実装としてダミーデータを遅延生成
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let newItems = (0..<10).map { index in
            createDummyIconSet(index: currentPage * 10 + index)
        }
        
        await MainActor.run {
            items.append(contentsOf: newItems)
            currentPage += 1
            hasMoreItems = currentPage < 3 // デモ用に3ページまで
            isLoading = false
        }
    }
    
    func loadInitialItems() async {
        currentPage = 0
        items = []
        await loadMoreItems()
    }
    
    private func createDummyIconSet(index: Int) -> IconSet {
        IconSet(
            id: UUID(),
            title: "\(category.rawValue) セット \(index + 1)",
            icons: (0..<4).map { _ in 
                IconSet.Icon(id: UUID(), imageUrl: "placeholder", targetAppBundleId: nil)
            },
            category: category,
            popularity: 100,
            createdAt: Date()
        )
    }
}
