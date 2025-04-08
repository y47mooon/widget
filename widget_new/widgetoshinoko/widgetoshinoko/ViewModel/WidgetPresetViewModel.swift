import Foundation
import SwiftUI
import Combine
import GaudiyWidgetShared

@MainActor
class WidgetPresetViewModel: ObservableObject {
    @Published private(set) var presets: [WidgetPreset] = []
    @Published private(set) var error: GaudiyWidgetShared.WidgetError?
    @Published private(set) var isLoading = false
    @Published private(set) var allPresets: [WidgetPreset] = []
    @Published private(set) var filteredPresets: [WidgetPreset] = []
    
    private let presetService: WidgetPresetService
    private let repository: WidgetPresetRepositoryProtocol
    
    init(
        repository: WidgetPresetRepositoryProtocol = FirebaseWidgetPresetRepository(),
        presetService: WidgetPresetService = .shared
    ) {
        self.repository = repository
        self.presetService = presetService
        self.presets = getInitialPresets()
    }
    
    // 初期表示用のプリセットを返す
    private func getInitialPresets() -> [WidgetPreset] {
        return [
            WidgetPreset(
                id: UUID(),
                title: "アナログ時計1",
                description: "クラシックデザインの時計",
                type: .analogClock,
                size: .small,
                style: "classic",
                imageUrl: "clock_analog_1",
                backgroundColor: nil,
                requiresPurchase: false,
                isPurchased: false,
                configuration: [:]
            ),
            WidgetPreset(
                id: UUID(),
                title: "アナログ時計2",
                description: "モダンデザインの時計",
                type: .analogClock,
                size: .small,
                style: "modern",
                imageUrl: "clock_analog_2",
                backgroundColor: nil,
                requiresPurchase: false,
                isPurchased: false,
                configuration: [:]
            ),
            // 必要な数だけ初期データを追加
        ]
    }
    
    func filterBySize(_ size: WidgetSize) {
        filteredPresets = presets.filter { $0.size == size }
    }

    // ウィジェットの基本タイプによるロード
    func loadPresets(type: WidgetType) async {
        isLoading = true
        error = nil
        
        do {
            let loadedPresets = try await repository.loadPresets()
            await MainActor.run {
                if !loadedPresets.isEmpty {
                    presets = loadedPresets.filter { $0.type == type }
                }
            }
        } catch {
            await MainActor.run {
                self.error = .fetchFailed(error)
            }
        }
        
        isLoading = false
    }

    // テンプレートタイプによるロード（統合版）
    @MainActor
    func loadPresets(templateType: WidgetTemplateType, size: WidgetSize? = nil) async {
        isLoading = true
        error = nil
        
        do {
            if let size = size {
                presets = try await repository.fetchPresetsBySize(templateType: templateType, size: size)
            } else {
                presets = try await repository.fetchPresets(templateType: templateType)
            }
        } catch {
            // Error型をWidgetError型に変換
            self.error = .fetchFailed(error)
        }
        
        isLoading = false
    }

    func getPresets(for category: WidgetCategory, size: WidgetSize? = nil) -> [WidgetPreset] {
        // カテゴリに応じたプリセットを取得
        var presets: [WidgetPreset] = []
        
        switch category {
        case GaudiyWidgetShared.WidgetCategory.clock:
            // 時計カテゴリの場合はアナログとデジタル時計のプリセットを取得
            let analogPresets = presetService.getPresets(type: .analogClock, size: size)
            let digitalPresets = presetService.getPresets(type: .digitalClock, size: size)
            presets = analogPresets + digitalPresets
        case GaudiyWidgetShared.WidgetCategory.weather:
            presets = presetService.getPresets(type: .weather, size: size)
        case GaudiyWidgetShared.WidgetCategory.calendar:
            presets = presetService.getPresets(type: .calendar, size: size)
        case GaudiyWidgetShared.WidgetCategory.popular:
            // 人気カテゴリの場合は全タイプから代表的なプリセットを取得
            for type in WidgetType.allCases {
                // 人気度に基づくフィルタリングを削除または別の条件に置き換え
                let typePresets = presetService.getPresets(type: type, size: size)
                // とりあえず先頭の1-2個を「人気」としてピックアップ
                if let firstPreset = typePresets.first {
                    presets.append(firstPreset)
                }
            }
        case GaudiyWidgetShared.WidgetCategory.photo:
            break
        case GaudiyWidgetShared.WidgetCategory.reminder, 
             GaudiyWidgetShared.WidgetCategory.date, 
             GaudiyWidgetShared.WidgetCategory.anniversary, 
             GaudiyWidgetShared.WidgetCategory.fortune, 
             GaudiyWidgetShared.WidgetCategory.memo:
            // これらのカテゴリに対応するプリセットがあれば取得
            // 現時点では特に処理がなければbreak
            break
        }
        
        if let size = size {
            return presets.filter { $0.size == size }
        }
        return presets
    }
    
    // サンプルプリセットを生成するヘルパーメソッド
    private func generateSamplePresets(for category: WidgetCategory, size: WidgetSize) -> [WidgetPreset] {
        var samplePresets: [WidgetPreset] = []
        
        switch category {
        case GaudiyWidgetShared.WidgetCategory.clock:
            // アナログ時計のサンプル
            samplePresets.append(
                WidgetPreset(
                    id: UUID(),
                    title: "シンプルアナログ時計",
                    description: "シンプルなデザインのアナログ時計",
                    type: .analogClock,
                    size: size,
                    style: "simple",
                    imageUrl: "clock_analog_simple",
                    backgroundColor: "#FFFFFF",
                    requiresPurchase: false,
                    isPurchased: true,
                    configuration: [
                        "textColor": "#000000",
                        "fontSize": size == .small ? 14.0 : (size == .medium ? 18.0 : 24.0),
                        "showSeconds": true
                    ]
                )
            )
            
            // デジタル時計のサンプル
            samplePresets.append(
                WidgetPreset(
                    id: UUID(),
                    title: "モダンデジタル時計",
                    description: "現代的なデザインのデジタル時計",
                    type: .digitalClock,
                    size: size,
                    style: "modern",
                    imageUrl: "clock_digital_modern",
                    backgroundColor: "#000000",
                    requiresPurchase: false,
                    isPurchased: true,
                    configuration: [
                        "textColor": "#FFFFFF",
                        "fontSize": size == .small ? 14.0 : (size == .medium ? 18.0 : 24.0),
                        "showSeconds": true
                    ]
                )
            )
            
        case GaudiyWidgetShared.WidgetCategory.weather:
            // 天気のサンプル
            samplePresets.append(
                WidgetPreset(
                    id: UUID(),
                    title: "標準天気ウィジェット",
                    description: "現在の天気と気温を表示",
                    type: .weather,
                    size: size,
                    style: "standard",
                    imageUrl: "weather_standard",
                    backgroundColor: "#E0F7FF",
                    requiresPurchase: false,
                    isPurchased: true,
                    configuration: [:]
                )
            )
            
        case GaudiyWidgetShared.WidgetCategory.calendar:
            // カレンダーのサンプル
            samplePresets.append(
                WidgetPreset(
                    id: UUID(),
                    title: "シンプルカレンダー",
                    description: "シンプルなカレンダーウィジェット",
                    type: .calendar,
                    size: size,
                    style: "simple",
                    imageUrl: "calendar_simple",
                    backgroundColor: "#FFFFFF",
                    requiresPurchase: false,
                    isPurchased: true,
                    configuration: [:]
                )
            )
            
        default:
            break
        }
        
        return samplePresets
    }
    
    // ホーム画面用のプリセット（各タイプの代表的なもの）
    func getHomeScreenPresets() -> [WidgetPreset] {
        let types: [WidgetType] = [.analogClock, .digitalClock, .weather, .calendar]
        var homeScreenPresets: [WidgetPreset] = []
        
        for type in types {
            if let preset = presetService.getPresets(type: type, size: .small).first {
                homeScreenPresets.append(preset)
            }
        }
        
        return homeScreenPresets
    }
    
    func saveWidget(_ widget: WidgetPreset) async throws {
        isLoading = true
        
        do {
            // UserDefaultsに保存
            try await saveToUserDefaults(widget)
            // ウィジェット拡張と共有
            try await shareWithWidgetExtension(widget)
            
            // 保存成功後、プリセットリストを更新
            presets.append(widget)
        } catch {
            throw GaudiyWidgetShared.WidgetError.saveFailed(error)
        }
        
        isLoading = false
    }
    
    private func saveToUserDefaults(_ widget: WidgetPreset) async throws {
        let userDefaults = UserDefaults(suiteName: "group.com.your.app")
        let encoder = JSONEncoder()
        let data = try encoder.encode(widget)
        userDefaults?.set(data, forKey: "savedWidgets")
    }
    
    private func shareWithWidgetExtension(_ widget: WidgetPreset) async throws {
        // ウィジェット拡張とデータを共有する処理
        // App GroupsとUserDefaultsを使用
    }
}

// モック用のリポジトリ（開発用）
class ViewModelMockWidgetPresetRepository: WidgetPresetRepositoryProtocol {
    func loadPresets() async throws -> [WidgetPreset] {
        // 実装
        var allPresets: [WidgetPreset] = []
        for type in WidgetType.allCases {
            allPresets.append(contentsOf: getMockPresets(templateType: type.templateType))
        }
        return allPresets
    }
    
    func fetchPresets(templateType: WidgetTemplateType) async throws -> [WidgetPreset] {
        // 実装
        return getMockPresets(templateType: templateType)
    }
    
    func fetchPresetsBySize(templateType: WidgetTemplateType, size: WidgetSize) async throws -> [WidgetPreset] {
        // 実装
        return getMockPresets(templateType: templateType, size: size)
    }
    
    // 既存のメソッド
    private func getMockPresets(templateType: WidgetTemplateType, size: WidgetSize? = nil) -> [WidgetPreset] {
        var presets: [WidgetPreset] = []
        let sizes = size != nil ? [size!] : WidgetSize.allCases
        
        // テンプレートタイプに対応するウィジェットタイプを取得
        let widgetTypes = WidgetType.getTypes(for: templateType)
        
        for s in sizes {
            for widgetType in widgetTypes {
                // テンプレートタイプとウィジェットタイプに基づいた設定
                let isDigitalClock = widgetType == .digitalClock
                let isDark = isDigitalClock || arc4random_uniform(2) == 1 // デジタル時計は常にダーク、他はランダム
                let style = isDark ? "dark" : "simple"
                let backgroundColor = isDark ? "#000000" : "#FFFFFF"
                let textColor = isDark ? "#FFFFFF" : "#000000"
                let title = "\(isDark ? "ダーク" : "シンプル")\(widgetType.displayName)"
                
                presets.append(
                    WidgetPreset(
                        id: UUID(),
                        title: title,
                        description: "\(isDark ? "ダークテーマ" : "シンプルなデザイン")の\(widgetType.displayName)ウィジェット",
                        type: widgetType,
                        size: s,
                        style: style,
                        imageUrl: "\(widgetType.rawValue)_\(style)",
                        backgroundColor: backgroundColor,
                        requiresPurchase: isDark, // ダークテーマは購入必要
                        isPurchased: false,
                        configuration: [
                            "textColor": textColor,
                            "fontSize": 24.0,
                            "showSeconds": true
                        ]
                    )
                )
            }
        }
        
        return presets
    }
}
