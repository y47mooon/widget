import SwiftUI      // ObservableObjectのために必要
import Combine      // @Publishedのために必要
import Foundation
import GaudiyWidgetShared

@MainActor
protocol IconListViewModelProtocol: ObservableObject {
    associatedtype Item
    var items: [Item] { get }
    var isLoading: Bool { get }
    var hasMoreItems: Bool { get }
    func loadMoreItems() async
    func loadInitialItems() async
}

/// アイコンリスト画面用のViewModel
@MainActor
class IconListViewModel: IconListViewModelProtocol {
    @Published private(set) var items: [IconSet] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMoreItems = true
    
    private let category: IconCategory
    private var currentPage = 0
    private let itemsPerPage = 10
    
    init(category: IconCategory) {
        self.category = category
    }
    
    /// 追加のアイテムを読み込む
    func loadMoreItems() async {
        guard !isLoading, hasMoreItems else { return }
        
        isLoading = true
        
        do {
            // 時間のかかる処理をシミュレート（実際のAPIリクエストなど）
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // データ生成（すでにMainActorコンテキストにいるので直接呼び出せる）
            let newItems = (0..<itemsPerPage).map { index in
                createDummyIconSet(index: currentPage * itemsPerPage + index)
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
    
    /// 初期アイテムを読み込む
    func loadInitialItems() async {
        currentPage = 0
        items = []
        hasMoreItems = true
        await loadMoreItems()
    }
    
    /// ダミーのアイコンセットを作成
    private func createDummyIconSet(index: Int) -> IconSet {
        let categoryValue = self.category // 明示的に参照
        let id = UUID()
        
        // アイコンを生成
        let icons = (0..<4).map { iconIndex in 
            IconSet.Icon(
                id: UUID(), 
                imageUrl: "https://picsum.photos/seed/icon\(index)_\(iconIndex)/200", 
                targetAppBundleId: getRandomAppBundleId()
            )
        }
        
        return IconSet(
            id: id,
            title: "\(categoryValue.displayName) セット \(index + 1)",
            icons: icons,
            category: categoryValue,
            createdAt: Date().addingTimeInterval(-Double.random(in: 0...86400*30)),
            popularity: Int.random(in: 50...500),
            previewUrl: "https://picsum.photos/seed/icon\(index)/400"
        )
    }
    
    /// ランダムなアプリのバンドルIDを取得（デモ用）
    private func getRandomAppBundleId() -> String? {
        let bundleIds = [
            "com.apple.MobileSMS",
            "com.apple.mobilephone",
            "com.apple.mobilesafari",
            "com.apple.camera",
            nil
        ]
        return bundleIds.randomElement() ?? nil
    }
}
