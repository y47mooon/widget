import Foundation
import GaudiyWidgetShared

#if canImport(FirebaseFirestore)
import FirebaseFirestore
// FirebaseFirestoreSwiftは使用せず、手動デコードに変更
#endif

// プロトコル定義は共有フレームワークに移動したため削除

#if canImport(FirebaseFirestore)
class FirebaseClockPresetRepository: ClockPresetRepository {
    private let db = Firestore.firestore()
    private let collection = "clock_presets"
    
    func fetchPresets() async throws -> [ClockPreset] {
        let snapshot = try await db.collection(collection).getDocuments()
        let presets = snapshot.documents.compactMap { document -> ClockPreset? in
            // 手動でドキュメントデータをデコード
            let data = document.data()
            
            // 基本情報を取得
            guard let idString = data["id"] as? String,
                  let id = UUID(uuidString: idString),
                  let title = data["title"] as? String,
                  let description = data["description"] as? String,
                  let thumbnailImageName = data["thumbnailImageName"] as? String,
                  let categoryRaw = data["category"] as? String,
                  let category = ClockPreset.PresetCategory(rawValue: categoryRaw),
                  let createdBy = data["createdBy"] as? String else {
                return nil
            }
            
            // 設定データを取得
            guard let configData = data["configuration"] as? [String: Any],
                  let styleRaw = configData["style"] as? String,
                  let style = ClockStyle(rawValue: styleRaw) else {
                return nil
            }
            
            let configuration = ClockConfiguration(style: style)
            
            return ClockPreset(
                id: id,
                title: title,
                description: description,
                thumbnailImageName: thumbnailImageName,
                configuration: configuration,
                category: category,
                createdBy: createdBy
            )
        }
        
        // App Groupにもデータを保存（ウィジェット用）
        WidgetDataService.shared.saveClockPresets(presets)
        
        return presets
    }
    
    func savePreset(_ preset: ClockPreset) async throws {
        // ドキュメントを手動でエンコード
        let documentRef = db.collection(collection).document(preset.id.uuidString)
        let data: [String: Any] = [
            "id": preset.id.uuidString,
            "title": preset.title,
            "description": preset.description,
            "thumbnailImageName": preset.thumbnailImageName,
            "category": preset.category.rawValue,
            "configuration": [
                "style": preset.configuration.style.rawValue
            ],
            "popularity": preset.popularity,
            "isFavorite": preset.isFavorite,
            "isPublic": preset.isPublic,
            "createdBy": preset.createdBy,
            "createdAt": preset.createdAt,
            "updatedAt": Date()
        ]
        
        try await documentRef.setData(data)
        
        // 保存後に全データを再取得してウィジェットを更新
        let presets = try await fetchPresets()
        WidgetDataService.shared.saveClockPresets(presets)
    }
    
    func updatePreset(_ preset: ClockPreset) async throws {
        // 同様に手動でエンコード
        let documentRef = db.collection(collection).document(preset.id.uuidString)
        let data: [String: Any] = [
            "title": preset.title,
            "description": preset.description,
            "thumbnailImageName": preset.thumbnailImageName,
            "category": preset.category.rawValue,
            "configuration": [
                "style": preset.configuration.style.rawValue
            ],
            "popularity": preset.popularity,
            "isFavorite": preset.isFavorite,
            "isPublic": preset.isPublic,
            "updatedAt": Date()
        ]
        
        try await documentRef.updateData(data)
        
        // 更新後に全データを再取得してウィジェットを更新
        let presets = try await fetchPresets()
        WidgetDataService.shared.saveClockPresets(presets)
    }
    
    func deletePreset(_ id: UUID) async throws {
        try await db.collection(collection).document(id.uuidString).delete()
        
        // 削除後に全データを再取得してウィジェットを更新
        let presets = try await fetchPresets()
        WidgetDataService.shared.saveClockPresets(presets)
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
#else
// ダミー実装も不要（WidgetClockPresetRepositoryを使用）
#endif
