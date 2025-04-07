import SwiftUI      // ObservableObjectのために必要
import Combine      // @Publishedのために必要

@MainActor
protocol IconListViewModelProtocol: ObservableObject {
    associatedtype Item
    var items: [Item] { get }
    var isLoading: Bool { get }
    var hasMoreItems: Bool { get }
    func loadMoreItems() async
    func loadInitialItems() async
}

@MainActor
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
        
        isLoading = true
        
        do {
            // 時間のかかる処理をシミュレート（実際のAPIリクエストなど）
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // データ生成（すでにMainActorコンテキストにいるので直接呼び出せる）
            let newItems = (0..<10).map { index in
                createDummyIconSet(index: currentPage * 10 + index)
            }
            
            // UI更新（すでにMainActorコンテキストにいるので直接更新できる）
            items.append(contentsOf: newItems)
            currentPage += 1
            hasMoreItems = currentPage < 3 // デモ用に3ページまで
        } catch {
            // エラー処理（実際のアプリではユーザーに通知するなど）
            print("データの読み込み中にエラーが発生しました: \(error)")
        }
        
        // 処理完了後、ローディング状態を解除
        isLoading = false
    }
    
    func loadInitialItems() async {
        currentPage = 0
        items = []
        await loadMoreItems()
    }
    
    private func createDummyIconSet(index: Int) -> IconSet {
        let categoryValue = self.category // 明示的に参照
        return IconSet(
            id: UUID(),
            title: "\(categoryValue.rawValue) セット \(index + 1)",
            icons: (0..<4).map { _ in 
                IconSet.Icon(id: UUID(), imageUrl: "placeholder", targetAppBundleId: nil)
            },
            category: categoryValue,
            popularity: 100,
            createdAt: Date()
        )
    }
}
