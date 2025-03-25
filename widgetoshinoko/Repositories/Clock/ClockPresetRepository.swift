import Foundation

protocol ClockPresetRepository {
    func fetchPresets() async throws -> [ClockPreset]
    func savePreset(_ preset: ClockPreset) async throws
    func updatePreset(_ preset: ClockPreset) async throws
    func deletePreset(_ id: UUID) async throws
    
    // 新しいメソッド：デフォルトプリセットの取得
    func getDefaultPresets() -> [ClockPreset]
}

class ClockPresetRepositoryImpl: ClockPresetRepository {
    // 定数を内部クラスに移動
    private enum Constants {
        static let appGroupID = "group.gaudy.widgetoshinoko"
        static let presetsKey = "clockPresets"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults? = nil) {
        self.userDefaults = userDefaults ?? UserDefaults(suiteName: Constants.appGroupID)!
    }
    
    func fetchPresets() async throws -> [ClockPreset] {
        if let data = userDefaults.data(forKey: Constants.presetsKey),
           let presets = try? JSONDecoder().decode([ClockPreset].self, from: data) {
            return presets
        }
        return []
    }
    
    func savePreset(_ preset: ClockPreset) async throws {
        var presets = try await fetchPresets()
        presets.append(preset)
        if let data = try? JSONEncoder().encode(presets) {
            userDefaults.set(data, forKey: Constants.presetsKey)
        }
    }
    
    func updatePreset(_ preset: ClockPreset) async throws {
        var presets = try await fetchPresets()
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
            if let data = try? JSONEncoder().encode(presets) {
                userDefaults.set(data, forKey: Constants.presetsKey)
            }
        }
    }
    
    func deletePreset(_ id: UUID) async throws {
        var presets = try await fetchPresets()
        presets.removeAll { $0.id == id }
        if let data = try? JSONEncoder().encode(presets) {
            userDefaults.set(data, forKey: Constants.presetsKey)
        }
    }
    
    func getDefaultPresets() -> [ClockPreset] {
        return [
            ClockPreset(
                title: "シンプルデジタル",
                description: "シンプルなデジタル時計",
                thumbnailImageName: "clock_digital",
                configuration: ClockConfiguration(style: .digital),
                category: .simple,
                createdBy: "system"
            ),
            ClockPreset(
                title: "クラシックアナログ",
                description: "クラシックなアナログ時計",
                thumbnailImageName: "clock_analog",
                configuration: ClockConfiguration(style: .analog),
                category: .classic,
                createdBy: "system"
            )
        ]
    }
}
