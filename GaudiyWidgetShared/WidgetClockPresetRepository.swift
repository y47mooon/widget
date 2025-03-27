//
//  WidgetClockPresetRepository.swift
//  GaudiyWidgetShared
//
//  Created by ゆぅ on 2025/03/26.
//

import Foundation

public class WidgetClockPresetRepository: ClockPresetRepository {
    private let userDefaults: UserDefaults?
    private let presetKey: String
    
    public init(groupID: String = Constants.appGroupID, presetKey: String = Constants.clockPresetKey) {
        self.userDefaults = UserDefaults(suiteName: groupID)
        self.presetKey = presetKey
    }
    
    public func fetchPresets() async throws -> [ClockPreset] {
        guard let data = userDefaults?.data(forKey: presetKey),
              let presets = try? JSONDecoder().decode([ClockPreset].self, from: data) else {
            return getDefaultPresets()
        }
        return presets
    }
    
    public func savePreset(_ preset: ClockPreset) async throws {
        // ウィジェットでは必要なし
    }
    
    public func updatePreset(_ preset: ClockPreset) async throws {
        // ウィジェットでは必要なし
    }
    
    public func deletePreset(_ id: UUID) async throws {
        // ウィジェットでは必要なし
    }
    
    public func getDefaultPresets() -> [ClockPreset] {
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
