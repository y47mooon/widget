import Foundation
import SwiftUI
import GaudiyWidgetShared

@MainActor
class ClockPresetsViewModel: ObservableObject {
    @Published private(set) var presets: [ClockPreset] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let presetRepository: ClockPresetRepository
    
    init(repository: ClockPresetRepository = RepositoryFactory.shared.makeClockPresetRepository()) {
        self.presetRepository = repository
        Task {
            await fetchPresets()
        }
    }
    
    // プリセット取得
    func fetchPresets() async {
        isLoading = true
        do {
            var fetchedPresets = try await presetRepository.loadPresets()
            
            // データが少なければサンプルデータを追加
            if fetchedPresets.isEmpty {
                fetchedPresets = getSamplePresets()
            }
            
            // 各サイズに少なくとも1つずつあるようにサンプルを追加
            var hasSmall = false
            var hasMedium = false
            var hasLarge = false
            
            for preset in fetchedPresets {
                switch preset.size {
                case .small: hasSmall = true
                case .medium: hasMedium = true
                case .large: hasLarge = true
                }
            }
            
            var additionalPresets: [ClockPreset] = []
            
            if !hasSmall {
                additionalPresets.append(contentsOf: getSamplePresets(for: .small))
            }
            
            if !hasMedium {
                additionalPresets.append(contentsOf: getSamplePresets(for: .medium))
            }
            
            if !hasLarge {
                additionalPresets.append(contentsOf: getSamplePresets(for: .large))
            }
            
            fetchedPresets.append(contentsOf: additionalPresets)
            presets = fetchedPresets
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            
            // エラー時はサンプルデータを使用
            presets = getSamplePresets()
        }
    }
    
    // サンプルプリセットを生成
    private func getSamplePresets() -> [ClockPreset] {
        var samples: [ClockPreset] = []
        
        // 小サイズのサンプル
        samples.append(contentsOf: getSamplePresets(for: .small))
        
        // 中サイズのサンプル
        samples.append(contentsOf: getSamplePresets(for: .medium))
        
        // 大サイズのサンプル
        samples.append(contentsOf: getSamplePresets(for: .large))
        
        return samples
    }
    
    // 特定サイズのサンプルプリセットを生成
    private func getSamplePresets(for size: WidgetSize) -> [ClockPreset] {
        var samples: [ClockPreset] = []
        let styles: [ClockStyle] = [.analog, .digital]
        let categories: [ClockCategory] = [.simple, .modern, .classic]
        
        for (index, style) in styles.enumerated() {
            let category = categories[index % categories.count]
            let title = style == .analog ? "アナログ時計" : "デジタル時計"
            let description = style == .analog ? "クラシックなデザイン" : "シンプルなデザイン"
            
            samples.append(
                ClockPreset(
                    id: UUID(),
                    title: "\(title) \(size.displayName)",
                    description: description,
                    style: style,
                    size: size,
                    imageUrl: "",
                    textColor: style == .analog ? "#000000" : "#FFFFFF",
                    fontSize: size == .small ? 14 : (size == .medium ? 18 : 24),
                    showSeconds: true,
                    category: category
                )
            )
        }
        
        return samples
    }
}
