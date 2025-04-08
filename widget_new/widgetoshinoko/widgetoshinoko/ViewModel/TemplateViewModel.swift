import Foundation
import GaudiyWidgetShared
import Combine

class TemplateViewModel: ObservableObject {
    @Published var allTemplates: [TemplateItem] = []
    @Published var templatesByCategory: [TemplateCategory: [TemplateItem]] = [:]
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var categoriesWithMoreTemplates: Set<TemplateCategory> = []
    private let repository: TemplateRepositoryProtocol
    
    init(repository: TemplateRepositoryProtocol = TemplateRepository()) {
        self.repository = repository
    }
    
    /// すべてのテンプレートを読み込む
    @MainActor
    func loadTemplates() async {
        isLoading = true
        error = nil
        
        do {
            // 全カテゴリのテンプレートを取得
            for category in TemplateCategory.allCases {
                let templates = try await repository.getTemplates(category: category, page: 1, limit: 10)
                
                // 取得したテンプレートをカテゴリごとに保存
                let templateItems = templates.map { TemplateItem(from: $0) }
                templatesByCategory[category] = templateItems
                
                // 次のページがあるかどうかの判定
                if templates.count == 10 {
                    categoriesWithMoreTemplates.insert(category)
                }
                
                // すべてのテンプレートにも追加
                allTemplates.append(contentsOf: templateItems)
            }
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    /// カテゴリごとに追加のテンプレートを読み込む
    @MainActor
    func loadMoreTemplates(for category: TemplateCategory, page: Int) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let templates = try await repository.getTemplates(category: category, page: page, limit: 10)
            let templateItems = templates.map { TemplateItem(from: $0) }
            
            // 既存のテンプレートに追加
            var currentTemplates = templatesByCategory[category] ?? []
            currentTemplates.append(contentsOf: templateItems)
            templatesByCategory[category] = currentTemplates
            
            // 次のページがあるかどうかの判定
            if templates.count < 10 {
                categoriesWithMoreTemplates.remove(category)
            } else {
                categoriesWithMoreTemplates.insert(category)
            }
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    /// 特定のカテゴリに表示するテンプレートを取得
    func getTemplates(for category: TemplateCategory) -> [TemplateItem] {
        return templatesByCategory[category] ?? []
    }
    
    /// 特定のIDのテンプレートを取得
    func getTemplate(by id: UUID) -> TemplateItem? {
        return allTemplates.first { $0.id == id }
    }
    
    /// 特定のカテゴリに表示するテンプレートをお気に入り数順に並べ替える
    func getSortedTemplates(for category: TemplateCategory, by sortOrder: TemplateSortOrder) -> [TemplateItem] {
        let templates = templatesByCategory[category] ?? []
        
        switch sortOrder {
        case .popularity:
            return templates.sorted(by: { $0.popularity > $1.popularity })
        case .newest:
            return templates.sorted(by: { $0.createdAt > $1.createdAt })
        }
    }
    
    /// 特定のカテゴリに続きのテンプレートがあるかどうか
    func hasMoreTemplates(for category: TemplateCategory) -> Bool {
        return categoriesWithMoreTemplates.contains(category)
    }
}

/// テンプレート詳細画面用ViewModel
class TemplateDetailViewModel: ObservableObject {
    @Published var template: TemplateItem?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: TemplateRepositoryProtocol
    
    init(repository: TemplateRepositoryProtocol = TemplateRepository()) {
        self.repository = repository
    }
    
    /// テンプレート詳細の読み込み
    @MainActor
    func loadTemplate(id: UUID) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let templateBase = try await repository.getTemplateDetails(id: id)
                self.template = TemplateItem(from: templateBase)
                self.isLoading = false
            } catch {
                self.error = error
                self.isLoading = false
            }
        }
    }
}

/// テンプレートの並べ替え順
enum TemplateSortOrder {
    case popularity
    case newest
}

// MARK: - レポジトリプロトコル
protocol TemplateRepositoryProtocol {
    func getTemplates(category: TemplateCategory, page: Int, limit: Int) async throws -> [TemplateBase]
    func getTemplateDetails(id: UUID) async throws -> TemplateBase
}

// MARK: - 実装クラス
class TemplateRepository: TemplateRepositoryProtocol {
    // 本番ではAPIを呼び出す
    func getTemplates(category: TemplateCategory, page: Int, limit: Int) async throws -> [TemplateBase] {
        // ダミーデータを返す
        return createDummyTemplates(for: category, count: limit)
    }
    
    func getTemplateDetails(id: UUID) async throws -> TemplateBase {
        // ダミーデータを返す
        return TemplateBase(
            id: id,
            title: "テンプレート詳細",
            description: "詳細な説明文がここに表示されます。",
            imageUrl: "https://picsum.photos/seed/\(id.uuidString)/400/600",
            category: .popular,
            popularity: Int.random(in: 50...500),
            createdAt: Date().addingTimeInterval(-Double.random(in: 0...86400*30))
        )
    }
    
    // カテゴリごとのダミーデータ生成
    private func createDummyTemplates(for category: TemplateCategory, count: Int) -> [TemplateBase] {
        return (0..<count).map { index in
            let id = UUID()
            let title: String
            
            switch category {
            case .popular:
                title = "人気テンプレート \(index + 1)"
            case .new:
                title = "新着テンプレート \(index + 1)"
            case .recommended:
                title = "おすすめテンプレート \(index + 1)"
            case .seasonal:
                title = "季節のテンプレート \(index + 1)"
            case .simple:
                title = "シンプルテンプレート \(index + 1)"
            case .minimal:
                title = "ミニマルテンプレート \(index + 1)"
            case .stylish:
                title = "スタイリッシュテンプレート \(index + 1)"
            }
            
            return TemplateBase(
                id: id,
                title: title,
                description: "テンプレートの説明文がここに表示されます。カテゴリ: \(category.displayName)",
                imageUrl: "https://picsum.photos/seed/\(id.uuidString)/400/600",
                category: category,
                popularity: Int.random(in: 50...500),
                createdAt: Date().addingTimeInterval(-Double.random(in: 0...86400*30))
            )
        }
    }
} 