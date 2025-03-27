//
//  ClockPresetRepository.swift
//  GaudiyWidgetShared
//
//  Created by ゆぅ on 2025/03/26.
//

import Foundation

public protocol ClockPresetRepository {
    func fetchPresets() async throws -> [ClockPreset]
    func savePreset(_ preset: ClockPreset) async throws
    func updatePreset(_ preset: ClockPreset) async throws
    func deletePreset(_ id: UUID) async throws
    func getDefaultPresets() -> [ClockPreset]
}
