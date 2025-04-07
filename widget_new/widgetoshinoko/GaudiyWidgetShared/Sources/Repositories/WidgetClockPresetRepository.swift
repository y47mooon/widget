import Foundation

public class WidgetClockPresetRepository: ClockPresetRepository {
    private let userDefaults: UserDefaults
    
    public init() {
        // アプリグループのUserDefaultsを使用
        self.userDefaults = UserDefaults(suiteName: SharedConstants.UserDefaults.appGroupID) ?? .standard
    }
    
    /// デフォルトのプリセットを取得
    /// Firebaseからのデータがない場合のフォールバック用
    public func getDefaultPresets() -> [ClockPreset] {
        return [
            ClockPreset(
                id: UUID(),
                title: "シンプルアナログ時計",
                description: "クラシックなデザインのアナログ時計",
                style: .analog,
                size: .small,
                imageUrl: nil,
                textColor: "#000000",
                fontSize: 14,
                showSeconds: true,
                category: .classic
            ),
            ClockPreset(
                id: UUID(),
                title: "モダンデジタル時計",
                description: "現代的なデザインのデジタル時計",
                style: .digital,
                size: .small,
                imageUrl: nil,
                textColor: "#FFFFFF",
                fontSize: 14,
                showSeconds: true,
                category: .modern
            )
        ]
    }
    
    /// ユーザーが選択したプリセット設定をローカルに保存
    /// 既存のプリセットを選択してカスタマイズした設定を保存する
    public func savePreset(_ preset: ClockPreset) async throws {
        var presets = try await loadPresets()
        
        // 既に同じIDのプリセットが存在する場合は置き換え、なければ追加
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
        } else {
            // 新規IDの場合は追加（既存プリセットの選択のみ）
            presets.append(preset)
        }
        
        // UserDefaultsに保存
        let encoder = JSONEncoder()
        let data = try encoder.encode(presets)
        userDefaults.set(data, forKey: SharedConstants.UserDefaults.clockPresetKey)
    }
    
    /// UserDefaultsからプリセット一覧を読み込む
    /// Firebaseから同期されたデータとユーザー選択を含む
    public func loadPresets() async throws -> [ClockPreset] {
        guard let data = userDefaults.data(forKey: SharedConstants.UserDefaults.clockPresetKey) else {
            return getDefaultPresets()
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([ClockPreset].self, from: data)
    }
    
    /// 特定のプリセットをユーザー選択から削除
    public func deletePreset(_ preset: ClockPreset) async throws {
        var presets = try await loadPresets()
        presets.removeAll { $0.id == preset.id }
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(presets)
        userDefaults.set(data, forKey: SharedConstants.UserDefaults.clockPresetKey)
    }
    
    /// ユーザーが選択可能なすべてのプリセットを取得
    /// FirebaseとUserDefaultsのデータをマージして返す
    public func getAllAvailablePresets() async throws -> [ClockPreset] {
        // UserDefaultsからユーザー選択プリセットを読み込む
        let userPresets = try await loadPresets()
        
        return userPresets
    }
}
