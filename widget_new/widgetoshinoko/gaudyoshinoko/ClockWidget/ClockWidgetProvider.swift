import WidgetKit
import Foundation
import GaudiyWidgetShared
import SwiftUI

struct ClockWidgetProvider: TimelineProvider {
    private let userDefaults = UserDefaults(suiteName: "group.gaudiy.widgetoshinoko")
    private let savedWidgetsKey = "savedWidgets"
    
    let repository = WidgetClockPresetRepository(
        groupID: "group.gaudiy.widgetoshinoko",
        presetKey: "saved_clock_presets"
    )
    
    func placeholder(in context: Context) -> ClockEntry {
        // プレースホルダー表示用
        let defaultConfig = GaudiyWidgetShared.ClockConfiguration(style: .digital, imageUrl: "", size: .small)
        return ClockEntry(configuration: defaultConfig, size: context.family.toWidgetSize())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        // スナップショット表示用
        let defaultConfig = GaudiyWidgetShared.ClockConfiguration(style: .digital, imageUrl: "", size: .small)
        let entry = ClockEntry(configuration: defaultConfig, size: context.family.toWidgetSize())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let size = context.family.toWidgetSize()
        
        Task {
            do {
                let presets = try await repository.fetchPresets()
                let currentDate = Date()
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                
                // サイズに合ったプリセットを取得
                let filteredPresets = presets.filter { $0.size == size }
                
                // プリセットがあればそれを使用、なければデフォルト
                if let preset = filteredPresets.first {
                    let config = convertToClockConfiguration(preset)
                    let entry = ClockEntry(date: currentDate, configuration: config, size: size)
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                    completion(timeline)
                } else {
                    // デフォルト設定
                    let defaultConfig = GaudiyWidgetShared.ClockConfiguration(style: .digital, imageUrl: "", size: size)
                    let entry = ClockEntry(date: currentDate, configuration: defaultConfig, size: size)
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                    completion(timeline)
                }
            } catch {
                // エラー時はデフォルト表示
                let currentDate = Date()
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                let defaultConfig = GaudiyWidgetShared.ClockConfiguration(style: .digital, imageUrl: "", size: size)
                let entry = ClockEntry(date: currentDate, configuration: defaultConfig, size: size)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            }
        }
    }
    
    // ClockPresetからClockConfigurationへの変換メソッドを修正
    private func convertToClockConfiguration(_ preset: GaudiyWidgetShared.ClockPreset) -> GaudiyWidgetShared.ClockConfiguration {
        return GaudiyWidgetShared.ClockConfiguration(
            style: preset.style,
            imageUrl: preset.imageUrl ?? "",
            size: preset.size,
            showSeconds: preset.showSeconds,
            fontSize: preset.fontSize ?? 14.0,
            textColor: preset.textColor ?? "#000000"
        )
    }
}

// WidgetFamily から WidgetSize への変換拡張
extension WidgetFamily {
    func toWidgetSize() -> GaudiyWidgetShared.WidgetSize {
        switch self {
        case .systemSmall: return .small
        case .systemMedium: return .medium
        case .systemLarge: return .large
        default: return .small
        }
    }
}
