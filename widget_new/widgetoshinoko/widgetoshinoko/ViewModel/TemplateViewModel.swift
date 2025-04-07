import Foundation
import SwiftUI
import Combine
import GaudiyWidgetShared

class TemplateViewModel: ObservableObject {
    @Published var templatesByCategory: [TemplateCategory: [TemplateItem]] = [:]
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    // 初期化時にデータを読み込む
    init() {
        loadAllTemplates()
    }
    
    // すべてのカテゴリのテンプレートを取得
    func loadAllTemplates() {
        isLoading = true
        
        // MainContentViewModelからデータを取得する実装に変更
        Task {
            do {
                // 各カテゴリのテンプレートを読み込む
                for category in TemplateCategory.allCases {
                    let contentItems = await MainContentViewModel.shared.getTemplateItems(for: category)
                    
                    // ContentItem<TemplateCategory>からTemplateItemに変換
                    let templateItems = contentItems.map { contentItem in
                        return TemplateItem(
                            id: contentItem.id,
                            title: contentItem.title,
                            description: contentItem.description,
                            imageUrl: contentItem.imageUrl,
                            category: contentItem.category,
                            popularity: contentItem.popularity,
                            createdAt: contentItem.createdAt
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.templatesByCategory[category] = templateItems
                    }
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    // 特定のカテゴリのテンプレートを取得
    func loadTemplates(for category: TemplateCategory) -> [TemplateItem] {
        return templatesByCategory[category] ?? []
    }
    
    // 特定のテンプレートを取得
    func getTemplate(with id: UUID) -> TemplateItem? {
        for (_, templates) in templatesByCategory {
            if let template = templates.first(where: { $0.id == id }) {
                return template
            }
        }
        return nil
    }
}

// カテゴリ別テンプレート一覧用ビューモデル
class TemplateCategoryViewModel: ObservableObject {
    @Published var templates: [TemplateItem] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let category: TemplateCategory
    
    init(category: TemplateCategory) {
        self.category = category
        loadTemplates()
    }
    
    // テンプレートを読み込む
    func loadTemplates() {
        isLoading = true
        
        Task {
            do {
                // MainContentViewModelからデータを取得
                let contentItems = await MainContentViewModel.shared.getTemplateItems(for: category)
                
                // ContentItem<TemplateCategory>からTemplateItemに変換
                let templateItems = contentItems.map { contentItem in
                    return TemplateItem(
                        id: contentItem.id,
                        title: contentItem.title,
                        description: contentItem.description,
                        imageUrl: contentItem.imageUrl,
                        category: contentItem.category,
                        popularity: contentItem.popularity,
                        createdAt: contentItem.createdAt
                    )
                }
                
                DispatchQueue.main.async {
                    self.templates = templateItems
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    // ページネーション用のメソッドを追加
    func loadNextPage() {
        // 既に読み込み中なら何もしない
        guard !isLoading else { return }
        
        isLoading = true
        
        // 実際の実装ではページ番号やオフセットを管理し、次のページのデータを取得する
        // 今回はサンプル実装として、既存のloadTemplates()を呼び出すだけにする
        Task {
            do {
                // 遅延を入れてロード中の表示を確認できるようにする
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待機
                
                // 今回は単純に同じデータを取得（実際の実装では次のページデータを取得）
                let contentItems = await MainContentViewModel.shared.getTemplateItems(for: category)
                
                // ContentItem<TemplateCategory>からTemplateItemに変換
                let newTemplateItems = contentItems.map { contentItem in
                    return TemplateItem(
                        id: UUID(), // 新しいIDを生成して重複を避ける（実際の実装ではAPIから取得したIDを使用）
                        title: contentItem.title,
                        description: contentItem.description,
                        imageUrl: contentItem.imageUrl,
                        category: contentItem.category,
                        popularity: contentItem.popularity,
                        createdAt: contentItem.createdAt
                    )
                }
                
                DispatchQueue.main.async {
                    // 既存のテンプレートに新しいテンプレートを追加
                    self.templates.append(contentsOf: newTemplateItems)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    // 特定のテンプレートを検索
    func getTemplate(with id: UUID) -> TemplateItem? {
        return templates.first(where: { $0.id == id })
    }
}

// テンプレート詳細用ビューモデル
class TemplateDetailViewModel: ObservableObject {
    @Published var template: TemplateItem?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var relatedTemplates: [TemplateItem] = []
    
    // テンプレート詳細を読み込む
    func loadTemplate(id: UUID) {
        isLoading = true
        
        // MainContentViewModelから該当するテンプレートを検索
        Task {
            do {
                // すべてのカテゴリから該当するテンプレートを検索
                for category in TemplateCategory.allCases {
                    let contentItems = await MainContentViewModel.shared.getTemplateItems(for: category)
                    if let contentItem = contentItems.first(where: { $0.id == id }) {
                        let templateItem = TemplateItem(
                            id: contentItem.id,
                            title: contentItem.title,
                            description: contentItem.description,
                            imageUrl: contentItem.imageUrl,
                            category: contentItem.category,
                            popularity: contentItem.popularity,
                            createdAt: contentItem.createdAt
                        )
                        
                        DispatchQueue.main.async {
                            self.template = templateItem
                            self.loadRelatedTemplates(category: templateItem.category)
                            self.isLoading = false
                        }
                        return
                    }
                }
                
                // テンプレートが見つからなかった場合
                DispatchQueue.main.async {
                    self.error = NSError(domain: "TemplateDetailViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "テンプレートが見つかりませんでした"])
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    // 関連テンプレートを読み込む
    private func loadRelatedTemplates(category: TemplateCategory) {
        Task {
            let contentItems = await MainContentViewModel.shared.getTemplateItems(for: category)
            
            // 同じカテゴリの他のテンプレートを最大4つまで取得
            let relatedContentItems = contentItems
                .filter { $0.id != template?.id }
                .prefix(4)
            
            // ContentItem<TemplateCategory>からTemplateItemに変換
            let relatedTemplateItems = relatedContentItems.map { contentItem in
                return TemplateItem(
                    id: contentItem.id,
                    title: contentItem.title,
                    description: contentItem.description,
                    imageUrl: contentItem.imageUrl,
                    category: contentItem.category,
                    popularity: contentItem.popularity,
                    createdAt: contentItem.createdAt
                )
            }
            
            DispatchQueue.main.async {
                self.relatedTemplates = relatedTemplateItems
            }
        }
    }
} 