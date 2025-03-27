import WidgetKit
import Foundation
import GaudiyWidgetShared
import SwiftUI

struct ClockWidgetProvider: TimelineProvider {
    // アプリグループIDを定数から取得
    private let userDefaults = UserDefaults(suiteName: Constants.appGroupID)!
    private let clockPresetKey = Constants.clockPresetKey
    
    // 直接共有フレームワークからリポジトリを作成
    let repository: ClockPresetRepository = WidgetClockPresetRepository(
        groupID: "group.gaudiy.widgetoshinoko", 
        presetKey: "clock_presets"
    )
    
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        let entry = ClockEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        // App Groupから取得したデータを使用
        Task {
            do {
                let presets = try await repository.fetchPresets()
                let currentDate = Date()
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                
                // シンプルにする場合（設定の読み込みなし）
                let entry = ClockEntry(date: currentDate)
                
                // 以下は設定を読み込む場合のコード
                // let entry: ClockEntry
                // if let data = userDefaults.data(forKey: clockPresetKey),
                //    let configuration = try? JSONDecoder().decode(ClockConfiguration.self, from: data) {
                //     // 設定があればそれを使用
                //     entry = ClockEntry(date: currentDate, configuration: configuration)
                // } else {
                //     // なければデフォルト
                //     entry = ClockEntry(date: currentDate)
                // }
                
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            } catch {
                // エラー処理
            }
        }
    }
}
