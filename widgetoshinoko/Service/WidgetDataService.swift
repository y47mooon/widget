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
        userDefaults?.set(data, forKey: customWidgetsKey)
        lastUpdated = Date()
        
        #if os(iOS)
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        #endif
    }
    
    // 時計プリセットをApp Groupに保存
    func saveClockPresets(_ presets: [ClockPreset]) {
        guard let data = try? JSONEncoder().encode(presets) else {
            print("Error encoding clock presets")
            return
        }
        userDefaults?.set(data, forKey: clockPresetsKey)
        lastUpdated = Date()
        
        // ウィジェットの更新（必要に応じて）
        #if os(iOS)
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        #endif
    }
    
    // Firebaseコンテンツの一部をキャッシュ
    func cacheContents(_ contents: [FirebaseContentItem]) {
        guard let data = try? JSONEncoder().encode(contents) else {
            print("Error encoding contents")
            return
        }
        userDefaults?.set(data, forKey: cachedContentsKey)
    }
    
    func reloadWidgets() {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            // 複数ウィジェットをサポートするための最適な方法
            WidgetCenter.shared.reloadAllTimelines()
            
            // または特定のウィジェットのみ更新する場合
            /*
            WidgetCenter.shared.reloadTimelines(ofKind: "ClockWidget.oshinoko")
            WidgetCenter.shared.reloadTimelines(ofKind: "SimpleWidget.oshinoko")
            WidgetCenter.shared.reloadTimelines(ofKind: "ControlWidget.oshinoko")
            */
        }
        #endif
    }
}
