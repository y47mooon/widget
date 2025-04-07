import Foundation
import SwiftUI
import GaudiyWidgetShared
import Combine
import WidgetKit

class WidgetDataService: ObservableObject {
    static let shared = WidgetDataService()
    
    @Published var lastUpdated: Date = Date()
    @Published var customWidgets: [CustomWidgetConfig] = []
    
    private let userDefaults = UserDefaults(suiteName: SharedConstants.UserDefaults.appGroupID)
    private let clockPresetsKey = SharedConstants.UserDefaults.clockPresetKey
    private let cachedContentsKey = SharedConstants.UserDefaults.cachedContentsKey
    private let customWidgetsKey = SharedConstants.UserDefaults.customWidgetsKey
    
    private init() {
        loadCustomWidgets()
    }
    
    // カスタムウィジェットの読み込み
    private func loadCustomWidgets() {
        guard let data = userDefaults?.data(forKey: customWidgetsKey),
              let widgets = try? JSONDecoder().decode([CustomWidgetConfig].self, from: data) else {
            return
        }
        customWidgets = widgets
    }
    
    // カスタムウィジェットの保存
    func saveCustomWidget(_ widget: CustomWidgetConfig) {
        customWidgets.append(widget)
        saveCustomWidgets()
    }
    
    private func saveCustomWidgets() {
        guard let data = try? JSONEncoder().encode(customWidgets) else {
            print("Error encoding custom widgets")
            return
        }
        
        // BaseRepositoryを使ってデータを同期
        let baseRepo = BaseRepository()
        baseRepo.syncToWidgetStorage(customWidgets, forKey: customWidgetsKey)
        lastUpdated = Date()
    }
    
    // Firebaseコンテンツの一部をキャッシュ
    func cacheContents(_ firebaseContents: [FirebaseContentItem]) {
        // FirebaseContentItemからContentへの変換
        let contents = firebaseContents.compactMap { ContentAdapter.toContent($0) }
        guard let data = try? JSONEncoder().encode(contents) else {
            print("Error encoding contents")
            return
        }
        userDefaults?.set(data, forKey: cachedContentsKey)
    }
    
    func getCachedContents() -> [Content] {
        guard let data = userDefaults?.data(forKey: cachedContentsKey),
              let contents = try? JSONDecoder().decode([Content].self, from: data) else {
            return []
        }
        return contents
    }
    
    func reloadWidgets() {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            // アナリティクスイベント送信
            AnalyticsService.shared.logEvent("widget_timelines_reloaded", parameters: nil)
            
            // BaseRepositoryを使ってウィジェットを更新
            let baseRepo = BaseRepository()
            // 更新トリガーとして現在時刻を保存
            baseRepo.syncToWidgetStorage(Date(), forKey: "widget_refresh_trigger")
        }
        #endif
    }
    
    // App Group内のデータを直接読み込むメソッドのみ維持
    func loadClockPresets() -> [ClockPreset] {
        guard let data = userDefaults?.data(forKey: clockPresetsKey),
              let presets = try? JSONDecoder().decode([ClockPreset].self, from: data) else {
            return []
        }
        return presets
    }
}
