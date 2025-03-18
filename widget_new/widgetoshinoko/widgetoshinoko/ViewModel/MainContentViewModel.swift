import Foundation
import SwiftUI

@MainActor
final class MainContentViewModel: ObservableObject {
    // 各カテゴリーのデータ
    @Published private(set) var templateItems: [ContentItem<TemplateCategory>] = []
    @Published private(set) var widgetItems: [WidgetItem] = []
    @Published private(set) var lockScreenItems: [ContentItem<LockScreenCategory>] = []
    @Published private(set) var wallpaperItems: [ContentItem<WallpaperCategory>] = []
    @Published private(set) var movingWallpaperItems: [ContentItem<MovingWallpaperCategory>] = []
    
    // カテゴリー別のデータを格納するディクショナリ
    @Published private(set) var templateItemsByCategory: [TemplateCategory: [ContentItem<TemplateCategory>]] = [:]
    @Published private(set) var widgetItemsByCategory: [WidgetCategory: [WidgetItem]] = [:]
    @Published private(set) var lockScreenItemsByCategory: [LockScreenCategory: [ContentItem<LockScreenCategory>]] = [:]
    @Published private(set) var wallpaperItemsByCategory: [WallpaperCategory: [ContentItem<WallpaperCategory>]] = [:]
    @Published private(set) var movingWallpaperItemsByCategory: [MovingWallpaperCategory: [ContentItem<MovingWallpaperCategory>]] = [:]
    
    @Published private(set) var isLoading = false
    
    // リポジトリ
    private let templateRepository: ContentRepositoryProtocol
    private let widgetRepository: WidgetRepositoryProtocol
    private let lockScreenRepository: ContentRepositoryProtocol
    private let wallpaperRepository: ContentRepositoryProtocol
    
    // 初期化
    init(
        templateRepository: ContentRepositoryProtocol = MockContentRepository(),
        widgetRepository: WidgetRepositoryProtocol = MockWidgetRepository(),
        lockScreenRepository: ContentRepositoryProtocol = MockContentRepository(),
        wallpaperRepository: ContentRepositoryProtocol = MockContentRepository()
    ) {
        self.templateRepository = templateRepository
        self.widgetRepository = widgetRepository
        self.lockScreenRepository = lockScreenRepository
        self.wallpaperRepository = wallpaperRepository
    }
    
    // 全データをロード
    func loadAllData() async {
        isLoading = true
        
        // テンプレートデータの読み込み
        await loadTemplateItems()
        
        // ウィジェットデータの読み込み
        await loadWidgetItems()
        
        // ロック画面データの読み込み
        await loadLockScreenItems()
        
        // 壁紙データの読み込み
        loadWallpaperItems()
        
        // 動く壁紙データの読み込み
        loadMovingWallpaperItems()
        
        isLoading = false
    }
    
    // テンプレートアイテムをロード
    private func loadTemplateItems(limit: Int = 5) async {
        do {
            // 人気のテンプレートをロード（ホーム画面用）
            self.templateItems = try await templateRepository.fetchItems(category: TemplateCategory.popular, limit: limit)
            
            // 各カテゴリー別にテンプレートをロード
            for category in TemplateCategory.allCases {
                let items = try await templateRepository.fetchItems(category: category, limit: limit)
                templateItemsByCategory[category] = items
            }
        } catch {
            print("テンプレートのロードに失敗: \(error)")
            // エラー処理（必要に応じて）
        }
    }
    
    // ウィジェットアイテムをロード
    private func loadWidgetItems(limit: Int = 5) async {
        do {
            // 人気のウィジェットをロード（ホーム画面用）
            // String?型を期待しているので、rawValueを渡す
            self.widgetItems = try await widgetRepository.fetchWidgets(category: WidgetCategory.popular.rawValue)
            
            // 各カテゴリー別にウィジェットをロード
            for category in WidgetCategory.allCases {
                let items = try await widgetRepository.fetchWidgets(category: category.rawValue)
                widgetItemsByCategory[category] = items
            }
        } catch {
            print("ウィジェットのロードに失敗: \(error)")
            // エラー処理（必要に応じて）
        }
    }
    
    // ロック画面アイテムをロード
    private func loadLockScreenItems(limit: Int = 5) async {
        do {
            // 人気のロック画面をロード（ホーム画面用）
            self.lockScreenItems = try await lockScreenRepository.fetchItems(category: LockScreenCategory.popular, limit: limit)
            
            // 各カテゴリー別にロック画面をロード
            for category in LockScreenCategory.allCases {
                let items = try await lockScreenRepository.fetchItems(category: category, limit: limit)
                lockScreenItemsByCategory[category] = items
            }
        } catch {
            print("ロック画面のロードに失敗: \(error)")
            // エラー処理（必要に応じて）
        }
    }
    
    // 壁紙アイテムをロード
    private func loadWallpaperItems(limit: Int = 5) {
        // 人気の壁紙をロード（ホーム画面用）
        wallpaperItems = getWallpaperItems(for: .popular)
        
        // 各カテゴリー別に壁紙をロード
        for category in WallpaperCategory.allCases {
            let items = getWallpaperItems(for: category)
            wallpaperItemsByCategory[category] = items
        }
    }
    
    // 動く壁紙アイテムをロード
    private func loadMovingWallpaperItems(limit: Int = 5) {
        // 人気の動く壁紙をロード（ホーム画面用）
        movingWallpaperItems = getMovingWallpaperItems(for: .popular)
        
        // 各カテゴリー別に動く壁紙をロード
        for category in MovingWallpaperCategory.allCases {
            let items = getMovingWallpaperItems(for: category)
            movingWallpaperItemsByCategory[category] = items
        }
    }
    
    // 特定カテゴリーのテンプレートアイテムを取得
    func getTemplateItems(for category: TemplateCategory) -> [ContentItem<TemplateCategory>] {
        return templateItemsByCategory[category] ?? []
    }
    
    // 特定カテゴリーのウィジェットアイテムを取得
    func getWidgetItems(for category: WidgetCategory) -> [WidgetItem] {
        return widgetItemsByCategory[category] ?? []
    }
    
    // 特定カテゴリーのロック画面アイテムを取得
    func getLockScreenItems(for category: LockScreenCategory) -> [ContentItem<LockScreenCategory>] {
        return lockScreenItemsByCategory[category] ?? []
    }
    
    // 特定カテゴリーの壁紙アイテムを取得
    func getWallpaperItems(for category: WallpaperCategory) -> [ContentItem<WallpaperCategory>] {
        // モックデータを返す
        return (0..<10).map { index in
            ContentItem(
                title: "\(category.rawValue) \(index + 1)",
                imageUrl: "wallpaper_placeholder",
                category: category,
                popularity: Int.random(in: 10...100)
            )
        }
    }
    
    // 動く壁紙アイテムを取得
    func getMovingWallpaperItems(for category: MovingWallpaperCategory) -> [ContentItem<MovingWallpaperCategory>] {
        // モックデータを返す
        return (0..<10).map { index in
            ContentItem(
                title: "\(category.rawValue) \(index + 1)",
                imageUrl: "moving_wallpaper_placeholder",
                category: category,
                popularity: Int.random(in: 10...100)
            )
        }
    }
}
