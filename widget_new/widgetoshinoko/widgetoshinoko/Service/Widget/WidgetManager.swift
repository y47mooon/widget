import Foundation
import GaudiyWidgetShared
import WidgetKit
import Combine

// MARK: - エラー定義
enum WidgetManagerError: Error, LocalizedError {
    case maxWidgetsReached(size: WidgetSize)
    case saveFailed
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .maxWidgetsReached(let size):
            return "\(size.displayName)サイズのウィジェットは最大数に達しています"
        case .saveFailed:
            return "ウィジェットの保存に失敗しました"
        case .notFound:
            return "ウィジェットが見つかりませんでした"
        }
    }
}

// MARK: - ウィジェット管理クラス
class WidgetManager: ObservableObject {
    static let shared = WidgetManager()
    
    @Published private var savedWidgets: [WidgetSize: [SavedWidget]] = [:]
    @Published private var presets: [String: WidgetPreset] = [:] // プリセットのキャッシュ
    private let maxWidgetsPerSize = 20
    private let userDefaults = UserDefaults(suiteName: "group.com.gaudiy.widgetoshinoko")!
    
    init() {
        loadFromUserDefaults()
    }
    
    // 保存済みウィジェットの取得
    func getWidgets(for size: WidgetSize) -> [SavedWidget] {
        return savedWidgets[size] ?? []
    }
    
    // 特定のインデックスのウィジェットを取得
    func getWidget(at index: Int, size: WidgetSize) -> SavedWidget? {
        let widgets = savedWidgets[size] ?? []
        guard index < widgets.count else { return nil }
        return widgets[index]
    }
    
    // ウィジェットの保存
    func saveWidget(_ widget: SavedWidget) throws {
        guard getWidgetCount(for: widget.size) < maxWidgetsPerSize else {
            throw WidgetError.limitExceeded
        }
        
        var widgets = savedWidgets[widget.size] ?? []
        widgets.append(widget)
        savedWidgets[widget.size] = widgets
        saveToUserDefaults()
    }
    
    // ウィジェットの並び替え
    func reorderWidgets(from source: IndexSet, to destination: Int, size: WidgetSize) {
        var widgets = savedWidgets[size] ?? []
        widgets.move(fromOffsets: source, toOffset: destination)
        savedWidgets[size] = widgets
        saveToUserDefaults()
    }
    
    // 残りスロット数の取得
    func remainingSlots(for size: WidgetSize) -> Int {
        let currentCount = getWidgetCount(for: size)
        return maxWidgetsPerSize - currentCount
    }
    
    // ウィジェット数の取得
    func getWidgetCount(for size: WidgetSize) -> Int {
        return savedWidgets[size]?.count ?? 0
    }
    
    // UserDefaultsからの読み込み
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "savedWidgets"),
           let decoded = try? JSONDecoder().decode([WidgetSize: [SavedWidget]].self, from: data) {
            savedWidgets = decoded
        }
    }
    
    // UserDefaultsへの保存
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedWidgets) {
            UserDefaults.standard.set(encoded, forKey: "savedWidgets")
        }
    }
    
    // プリセットの取得
    func getPreset(for id: String) -> WidgetPreset? {
        return presets[id]
    }
    
    // ウィジェットの削除
    func removeWidget(id: UUID) {
        for size in WidgetSize.allCases {
            if var widgets = savedWidgets[size] {
                widgets.removeAll { $0.id == id }
                savedWidgets[size] = widgets
            }
        }
        saveToUserDefaults()
    }
    
    // ウィジェット数の取得
    func widgetCount(for size: WidgetSize) -> Int {
        return savedWidgets[size]?.count ?? 0
    }
    
    // ウィジェットタイプごとのプリセット取得
    func getPresets(for type: WidgetType) -> [WidgetPreset] {
        return presets.values.filter { $0.type == type }
    }
    
    // ウィジェットタイプごとの保存済みウィジェット取得
    func getSavedWidgets(for type: WidgetType) -> [SavedWidget] {
        return WidgetSize.allCases.flatMap { size in
            getWidgets(for: size).filter { widget in
                if let preset = getPreset(for: widget.presetId) {
                    return preset.type == type
                }
                return false
            }
        }
    }
    
    func addWidget(preset: WidgetPreset, size: WidgetSize) throws {
        let widget = SavedWidget(
            id: UUID(),
            presetId: preset.id.uuidString,
            size: size,
            type: preset.type,
            configuration: GaudiyWidgetShared.WidgetConfiguration(from: preset.configuration)
        )
        
        try saveWidget(widget)
    }
    
    // 新しい機能を追加
    func saveSelectedPreset(_ preset: WidgetPreset) {
        if let data = try? JSONEncoder().encode(preset) {
            userDefaults.set(data, forKey: "selected_preset")
        }
    }
}

enum WidgetError: Error {
    case limitExceeded
    
    var localizedDescription: String {
        switch self {
        case .limitExceeded:
            return "ウィジェットの上限（20個）に達しました"
        }
    }
}
