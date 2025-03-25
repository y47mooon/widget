import Foundation
import SwiftUI

@MainActor
class ClockPresetsViewModel: ObservableObject {
    @Published private(set) var presets: [ClockPreset] = []
    @Published private(set) var userCustomPresets: [ClockPreset] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let presetRepository: ClockPresetRepository
    
    init(repository: ClockPresetRepository = ClockPresetRepositoryImpl()) {
        self.presetRepository = repository
        // デフォルトプリセットの追加
        Task {
            await loadDefaultPresetsIfNeeded()
        }
    }
    
    // デフォルトプリセットの追加処理
    private func loadDefaultPresetsIfNeeded() async {
        let currentPresets = try? await presetRepository.fetchPresets()
        if currentPresets?.isEmpty ?? true {
            let defaults = [
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
                // 他のデフォルトプリセットも追加可能
            ]
            
            for preset in defaults {
                try? await presetRepository.savePreset(preset)
            }
        }
    }
    
    // プリセット取得
    func fetchPresets() async {
        isLoading = true
        do {
            presets = try await presetRepository.fetchPresets()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    // カスタムプリセット保存
    func saveCustomPreset(_ preset: ClockPreset) async {
        do {
            try await presetRepository.savePreset(preset)
            await fetchPresets()
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }
}
