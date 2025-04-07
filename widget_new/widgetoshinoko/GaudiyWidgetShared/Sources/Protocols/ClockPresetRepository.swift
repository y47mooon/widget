import Foundation

public protocol ClockPresetRepository {
    func getDefaultPresets() -> [ClockPreset]
    func savePreset(_ preset: ClockPreset) async throws
    func loadPresets() async throws -> [ClockPreset]
    func deletePreset(_ preset: ClockPreset) async throws
}
