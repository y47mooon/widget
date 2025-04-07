import Foundation
import SwiftUI
import GaudiyWidgetShared
import os.log

@MainActor
final class MainContentViewModel: ObservableObject {
    // シングルトンインスタンス
    static let shared = MainContentViewModel()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.gaudiy.widgetoshinoko", category: "MainContentViewModel")
    // 各カテゴリーのデータ
    @Published var templateItems: [ContentItem<TemplateCategory>] = []
    @Published var widgetItems: [WidgetItem] = []
    @Published var lockScreenItems: [ContentItem<LockScreenCategory>] = []
    @Published var wallpaperItems: [ContentItem<WallpaperCategory>] = []
    @Published var movingWallpaperItems: [ContentItem<MovingWallpaperCategory>] = []
    
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
    
    // アイコン関連のプロパティ
    @Published private(set) var iconItemsByCategory: [IconCategory: [IconSet]] = [:]
    
    @Published var widgetCategories: [WidgetCategory] = []
    @Published var selectedSection: String = ""
    
    @Published private var _clockPresets: [ClockPreset] = []
    
    // 公開プロパティはcomputedプロパティ経由で提供
    var clockPresets: [ClockPreset] {
        return _clockPresets
    }
    
    // データロード用のタスクを保持
    private var loadingTask: Task<Void, Never>?
    
    // 新しいプロパティ
    @Published var selectedWidgetType: WidgetType = .analogClock
    @Published var selectedPreset: WidgetPreset?
    @Published var selectedClockSize: WidgetSize = .small
    
    @Published var weatherPresets: [WidgetPreset] = []
    @Published var calendarPresets: [WidgetPreset] = []
    
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
        
        // ウィジェットカテゴリーの初期化
        widgetCategories = [
            .popular,
            .weather,
            .calendar,
            .reminder,
            .date,
            .anniversary,
            .fortune,
            .memo
        ]
        
        // 初期データをすぐに設定（同期的処理）
        let initialWidgets = getInitialWidgets()
        self.widgetItems = initialWidgets
        
        // カテゴリー別のデータも初期状態で必ず更新
        for category in [WidgetCategory.clock, .weather, .calendar, .popular, .photo] {
            let items = initialWidgets.filter { $0.category == category.rawValue }
            self.widgetItemsByCategory[category] = items
        }
        
        // 壁紙とロック画面の初期データも設定
        self.wallpaperItems = getWallpaperItems(for: .popular)
        self.lockScreenItems = getMockLockScreenItems()
        self.movingWallpaperItems = getMovingWallpaperItems(for: .popular)
        
        // 非同期でさらにデータを読み込む (遅延実行)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Task {
                await self.loadClockPresets()  // 時計プリセットの読み込み
                await self.loadAllData()       // 他のデータの読み込み
            }
        }
    }
    
    // 全データをロード
    func loadAllData() async {
        // 既存のタスクをキャンセル
        loadingTask?.cancel()
        
        loadingTask = Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true
            
            do {
                // 各セクションのデータを順次読み込む
                if !Task.isCancelled {
                    await loadTemplateItems()
                }
                
                if !Task.isCancelled {
                    await loadWidgetItems()
                }
                
                if !Task.isCancelled {
                    await loadLockScreenItems()
                }
                
                if !Task.isCancelled {
                    await loadWallpaperItems()
                }
                
                if !Task.isCancelled {
                    await loadMovingWallpaperItems()
                }
                
                // 天気とカレンダーのプリセットを読み込む
                weatherPresets = WidgetPresetService.shared.getPresets(type: .weather)
                calendarPresets = WidgetPresetService.shared.getPresets(type: .calendar)
                
                logger.debug("🔍 All data loaded successfully")
            } catch {
                logger.error("Error loading data: \(error.localizedDescription)")
            }
            
            isLoading = false
        }
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
        guard !Task.isCancelled else { return }
        
        do {
            await MainActor.run {
                isLoading = true
            }
            
            // 初期データが既に設定されているか確認
            if self.widgetItems.isEmpty {
                await MainActor.run {
                    // 初期データをセット
                    let initialWidgets = getInitialWidgets()
                    self.widgetItems = initialWidgets
                    
                    // カテゴリー別のデータも更新
                    for category in [WidgetCategory.clock, .weather, .calendar, .popular, .photo] {
                        let categoryWidgets = initialWidgets.filter { $0.category == category.rawValue }
                        self.widgetItemsByCategory[category] = categoryWidgets
                    }
                }
            }
            
            // 新しいデータを取得
            let newItems = try await widgetRepository.fetchWidgets(category: WidgetCategory.popular.rawValue)
            
            guard !Task.isCancelled else { return }
            
            // 新しいデータが有効な場合のみ更新
            if !newItems.isEmpty {
                await MainActor.run {
                    // 既存のデータを保持しながら新しいデータを追加
                    var updatedItems = self.widgetItems
                    
                    // 重複を避けるためにIDでフィルタリング
                    let existingIds = Set(updatedItems.map { $0.id })
                    let newUniqueItems = newItems.filter { !existingIds.contains($0.id) }
                    
                    // 新しいアイテムを追加
                    updatedItems.append(contentsOf: newUniqueItems)
                    
                    // ユニークな最新のアイテムを設定
                    self.widgetItems = updatedItems
                    
                    // カテゴリー別のデータも更新
                    for category in [WidgetCategory.clock, .weather, .calendar, .popular, .photo] {
                        let categoryItems = updatedItems.filter { $0.category == category.rawValue }
                        self.widgetItemsByCategory[category] = categoryItems
                    }
                }
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                // エラー時は初期データがあることを確認
                if self.widgetItems.isEmpty {
                    self.widgetItems = getInitialWidgets()
                    
                    for category in [WidgetCategory.clock, .weather, .calendar, .popular, .photo] {
                        let categoryItems = self.widgetItems.filter { $0.category == category.rawValue }
                        self.widgetItemsByCategory[category] = categoryItems
                    }
                }
                
                self.isLoading = false
                logger.error("ウィジェットのロードに失敗: \(error.localizedDescription)")
            }
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
    
    // アイコンデータを取得
    func getIconItems(for category: IconCategory) -> [IconSet] {
        return iconItemsByCategory[category] ?? []
    }
    
    // 初期ウィジェットデータ
    private func getInitialWidgets() -> [WidgetItem] {
        let categories: [WidgetCategory] = [.popular, .weather, .calendar, .clock]
        var allWidgets: [WidgetItem] = []
        
        for category in categories {
            let widgets = (0..<5).map { index in
                WidgetItem(
                    id: UUID(),
                    title: "\(category.displayName) \(index + 1)",
                    description: "サンプルウィジェット",
                    imageUrl: "widget_placeholder",
                    category: category.rawValue,
                    popularity: Int.random(in: 50...100),
                    createdAt: Date()
                )
            }
            allWidgets.append(contentsOf: widgets)
        }
        
        return allWidgets
    }
    
    private func loadClockPresets() async {
        let repository = RepositoryFactory.shared.makeClockPresetRepository()
        do {
            _clockPresets = try await repository.loadPresets()
        } catch {
            print("クロックプリセット読み込みエラー: \(error)")
            // エラー処理は既存のままで問題ありません
            if let firebaseRepo = repository as? FirebaseClockPresetRepository {
                _clockPresets = firebaseRepo.getDefaultPresets()
            } else {
                _clockPresets = [] // 空の配列を使用
            }
        }
    }
    
    // ViewModelが破棄されるときにタスクをキャンセル
    deinit {
        loadingTask?.cancel()
    }
    
    private func loadInitialData() async {
        await MainActor.run {
            isLoading = true
            
            // 初期データを設定
            let initialWidgets = getInitialWidgets()
            self.widgetItems = initialWidgets
            
            // カテゴリー別のデータも更新
            for category in [WidgetCategory.clock, .weather, .calendar, .popular, .photo] {
                let categoryWidgets = initialWidgets.filter { $0.category == category.rawValue }
                self.widgetItemsByCategory[category] = categoryWidgets
            }
            
            isLoading = false
        }
    }
    
    // ロック画面の初期モックデータ
    private func getMockLockScreenItems() -> [ContentItem<LockScreenCategory>] {
        return (0..<5).map { index in
            ContentItem(
                title: "ロック画面サンプル \(index + 1)",
                imageUrl: "lockscreen_placeholder",
                category: LockScreenCategory.popular,
                popularity: Int.random(in: 10...100)
            )
        }
    }
    
    // 時計プリセットを取得する関数
    func getClockPresets(limit: Int = 0) -> [WidgetPreset] {
        let service = WidgetPresetService.shared
        // アナログとデジタル両方の時計を取得
        var presets = service.getPresets(type: .analogClock) + 
                      service.getPresets(type: .digitalClock)
        
        // サイズでフィルタリング（オプション）
        presets = presets.filter { $0.size == selectedClockSize }
        
        // 人気順にソート（仮実装）
        presets.sort { _, _ in Bool.random() }
        
        // 件数制限
        if limit > 0 && presets.count > limit {
            return Array(presets.prefix(limit))
        }
        
        return presets
    }
    
    func getWeatherPresets(limit: Int = 8) -> [WidgetPreset] {
        return WidgetPresetService.shared.getPresets(type: .weather)
            .prefix(limit)
            .map { $0 }
    }
    
    func getCalendarPresets(limit: Int = 8) -> [WidgetPreset] {
        return WidgetPresetService.shared.getPresets(type: .calendar)
            .prefix(limit)
            .map { $0 }
    }
}
