import Foundation
import SwiftUI
import GaudiyWidgetShared

@MainActor
class ClockPresetsViewModel: ObservableObject {
    @Published private(set) var presets: [ClockPreset] = []
    @Published private(set) var userCustomPresets: [ClockPreset] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let presetRepository: ClockPresetRepository
    
    init(repository: ClockPresetRepository = RepositoryFactory.shared.makeClockPresetRepository()) {
        self.presetRepository = repository
        // デフォルトプリセットの追加
        Task {
            await loadDefaultPresetsIfNeeded()
        }
    }
    
    // デフォルトプリセットの追加処理
    private func loadDefaultPresetsIfNeeded() async {
        do {
            let currentPresets = try await presetRepository.fetchPresets()
            if currentPresets.isEmpty {
                let defaults = presetRepository.getDefaultPresets()
                
                for preset in defaults {
                    do {
                        try await presetRepository.savePreset(preset)
                    } catch {
                        // エラーログ出力
                        print("プリセット保存エラー: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            // エラーハンドリング
            self.error = error
            print("プリセット取得エラー: \(error.localizedDescription)")
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
