import Foundation

protocol ClockPresetRepository {
    func fetchPresets() async throws -> [ClockPreset]
    func savePreset(_ preset: ClockPreset) async throws
    func updatePreset(_ preset: ClockPreset) async throws
    func deletePreset(_ id: UUID) async throws
}

class ClockPresetRepositoryImpl: ClockPresetRepository {
    private let userDefaults = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")!
    private let presetsKey = "clockPresets"
    
    func fetchPresets() async throws -> [ClockPreset] {
        if let data = userDefaults.data(forKey: presetsKey),
           let presets = try? JSONDecoder().decode([ClockPreset].self, from: data) {
            return presets
        }
        return []
    }
    
    func savePreset(_ preset: ClockPreset) async throws {
        var presets = try await fetchPresets()
        presets.append(preset)
        if let data = try? JSONEncoder().encode(presets) {
            userDefaults.set(data, forKey: presetsKey)
        }
    }
    
    func updatePreset(_ preset: ClockPreset) async throws {
        var presets = try await fetchPresets()
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
            if let data = try? JSONEncoder().encode(presets) {
                userDefaults.set(data, forKey: presetsKey)
            }
        }
    }
    
    func deletePreset(_ id: UUID) async throws {
        var presets = try await fetchPresets()
        presets.removeAll { $0.id == id }
        if let data = try? JSONEncoder().encode(presets) {
            userDefaults.set(data, forKey: presetsKey)
        }
    }
}
