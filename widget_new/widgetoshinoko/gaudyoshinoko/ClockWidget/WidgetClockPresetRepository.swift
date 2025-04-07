import Foundation
import GaudiyWidgetShared

// GaudiyWidgetSharedの型を使用
typealias WidgetClockPreset = GaudiyWidgetShared.ClockPreset
typealias ClockStyle = GaudiyWidgetShared.ClockStyle
typealias WidgetSize = GaudiyWidgetShared.WidgetSize

class WidgetClockPresetRepository {
    private let groupID: String
    private let presetKey: String
    private let userDefaults: UserDefaults?
    
    init(groupID: String, presetKey: String) {
        self.groupID = groupID
        self.presetKey = presetKey
        self.userDefaults = UserDefaults(suiteName: groupID)
    }
    
    func fetchPresets() async throws -> [GaudiyWidgetShared.ClockPreset] {
        // UserDefaultsからプリセットを読み込む簡易実装
        guard let data = userDefaults?.data(forKey: presetKey),
              let presets = try? JSONDecoder().decode([GaudiyWidgetShared.ClockPreset].self, from: data) else {
            return []  // データがなければ空配列を返す
        }
        return presets
    }
}
