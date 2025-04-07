import Foundation
import WidgetKit

public class WidgetDataManager {
    public static let shared = WidgetDataManager()
    
    private let userDefaults: UserDefaults?
    private let widgetKey = "savedWidgets"
    private let maxWidgetsPerSize = 20
    private let updateInterval: TimeInterval = 900 // 15分
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.gaudiy.widgetoshinoko")
    }
    
    // MARK: - Public Methods
    
    public func saveWidget(_ widget: OshinokoWidget) throws {
        var widgets = getSavedWidgets()
        
        // サイズごとの制限チェック
        let sizeWidgets = widgets.filter { $0.size == widget.size }
        guard sizeWidgets.count < maxWidgetsPerSize else {
            throw WidgetError.limitExceeded
        }
        
        // 既存のウィジェットを更新または新規追加
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            widgets[index] = widget
        } else {
            widgets.append(widget)
        }
        
        try saveWidgets(widgets)
        reloadTimelines()
    }
    
    public func removeWidget(id: UUID) {
        var widgets = getSavedWidgets()
        widgets.removeAll { $0.id == id }
        try? saveWidgets(widgets)
        reloadTimelines()
    }
    
    public func getWidgets(for size: WidgetSize) -> [OshinokoWidget] {
        return getSavedWidgets().filter { $0.size == size }
    }
    
    public func getNextUpdateDate() -> Date {
        return Date().addingTimeInterval(updateInterval)
    }
    
    public func saveMessage(_ message: String) {
        userDefaults?.set(message, forKey: "widget_message")
        reloadTimelines()
    }
    
    public func getMessage() -> String {
        return userDefaults?.string(forKey: "widget_message") ?? "デフォルトメッセージ"
    }
    
    // MARK: - Private Methods
    
    private func getSavedWidgets() -> [OshinokoWidget] {
        guard let data = userDefaults?.data(forKey: widgetKey),
              let widgets = try? JSONDecoder().decode([OshinokoWidget].self, from: data) else {
            return []
        }
        return widgets
    }
    
    private func saveWidgets(_ widgets: [OshinokoWidget]) throws {
        let data = try JSONEncoder().encode(widgets)
        userDefaults?.set(data, forKey: widgetKey)
    }
    
    private func reloadTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func cleanupOldData() {
        var widgets = getSavedWidgets()
        widgets.sort { $0.updatedAt > $1.updatedAt }
        
        // サイズごとに最新の20個のみ保持
        var newWidgets: [OshinokoWidget] = []
        for size in WidgetSize.allCases {
            let sizeWidgets = widgets.filter { $0.size == size }
            newWidgets.append(contentsOf: Array(sizeWidgets.prefix(maxWidgetsPerSize)))
        }
        
        try? saveWidgets(newWidgets)
    }
}
