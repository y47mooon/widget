import Foundation
import Firebase
import FirebaseFirestore
import GaudiyWidgetShared

#if canImport(FirebaseFirestore)
import FirebaseFirestore
// FirebaseFirestoreSwiftは使用せず、手動デコードに変更
#endif

// プロトコル定義は共有フレームワークに移動したため削除

#if canImport(FirebaseFirestore)
/// Firebaseから管理者が設定したプリセットを取得するリポジトリ
class FirebaseClockPresetRepository: BaseRepository, ClockPresetRepository {
    private let db = Firestore.firestore()
    private let collection = "clock_presets"
    
    /// Firebaseからプリセットを取得して、WidgetStorage（UserDefaults）と同期する
    func fetchPresets() async throws -> [ClockPreset] {
        let snapshot = try await db.collection(collection)
            .whereField("type", isEqualTo: "clock")
            .getDocuments()
            
        let presets = snapshot.documents.compactMap { document -> ClockPreset? in
            let data = document.data()
            
            // 基本情報を取得
            guard let title = data["title"] as? String,
                  let description = data["description"] as? String,
                  let styleRaw = data["style"] as? String,
                  let style = ClockStyle(rawValue: styleRaw),
                  let sizeRaw = data["size"] as? String,
                  let size = WidgetSize(rawValue: sizeRaw),
                  let imageUrl = data["imageUrl"] as? String,
                  let categoryRaw = data["category"] as? String,
                  let category = ClockCategory(rawValue: categoryRaw),
                  let createdBy = data["createdBy"] as? String else {
                return nil
            }
            
            return ClockPreset(
                id: UUID(uuidString: document.documentID) ?? UUID(),
                title: title,
                description: description,
                style: style,
                size: size,
                imageUrl: imageUrl,
                textColor: data["textColor"] as? String ?? "#000000",
                fontSize: data["fontSize"] as? Double ?? 14.0,
                showSeconds: data["showSeconds"] as? Bool ?? false,
                category: category,
                popularity: data["popularity"] as? Int ?? 0,
                isPublic: data["isPublic"] as? Bool ?? true,
                createdBy: createdBy,
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
        
        // 取得したデータをWidgetと同期
        syncToWidgetStorage(presets, forKey: SharedConstants.UserDefaults.clockPresetKey)
        
        return presets
    }
    
    /// 管理者向け機能: Firebaseにプリセットを保存する（通常のユーザーは使用しない）
    /// - 注: この機能は管理者のみが使用できる
    func savePreset(_ preset: ClockPreset) async throws {
        #if DEBUG
        // デバッグビルドでのみ許可する
        let data = try JSONEncoder().encode(preset)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        try await db.collection(collection)
            .document(preset.id.uuidString)
            .setData(dict)
        
        // アナリティクスイベントを修正
        AnalyticsService.shared.logEvent("admin_preset_saved", parameters: [
            "preset_id": preset.id.uuidString,
            "category": preset.category.rawValue
        ])
        
        // 保存後にWidgetと同期
        let presets = try await fetchPresets()
        syncToWidgetStorage(presets, forKey: SharedConstants.UserDefaults.clockPresetKey)
        #else
        throw NSError(domain: "com.gaudiy.widgetoshinoko", code: 403, userInfo: [
            NSLocalizedDescriptionKey: "この機能は管理者のみが使用できます"
        ])
        #endif
    }
    
    /// 管理者向け機能: Firebaseでプリセットを更新する（通常のユーザーは使用しない）
    /// - 注: この機能は管理者のみが使用できる
    func updatePreset(_ preset: ClockPreset) async throws {
        #if DEBUG
        // デバッグビルドでのみ許可する
        let documentRef = db.collection(collection).document(preset.id.uuidString)
        let data: [String: Any] = [
            "title": preset.title,
            "description": preset.description,
            "style": preset.style.rawValue,
            "imageUrl": preset.imageUrl as Any,
            "textColor": preset.textColor as Any,
            "fontSize": preset.fontSize as Any,
            "showSeconds": preset.showSeconds,
            "category": preset.category.rawValue,
            "popularity": preset.popularity,
            "isPublic": preset.isPublic,
            "updatedAt": Timestamp(date: Date())
        ]
        
        try await documentRef.updateData(data)
        
        // 削除後の同期処理を一元化メソッドに置き換え
        let presets = try await fetchPresets()
        syncToWidgetStorage(presets, forKey: SharedConstants.UserDefaults.clockPresetKey)
        #else
        throw NSError(domain: "com.gaudiy.widgetoshinoko", code: 403, userInfo: [
            NSLocalizedDescriptionKey: "この機能は管理者のみが使用できます"
        ])
        #endif
    }
    
    /// 管理者向け機能: Firebaseからプリセットを削除する（通常のユーザーは使用しない）
    /// - 注: この機能は管理者のみが使用できる
    func deletePreset(id: UUID) async throws {
        #if DEBUG
        // デバッグビルドでのみ許可する
        try await db.collection(collection).document(id.uuidString).delete()
        
        // 削除後の同期処理を一元化メソッドに置き換え
        let presets = try await fetchPresets()
        syncToWidgetStorage(presets, forKey: SharedConstants.UserDefaults.clockPresetKey)
        #else
        throw NSError(domain: "com.gaudiy.widgetoshinoko", code: 403, userInfo: [
            NSLocalizedDescriptionKey: "この機能は管理者のみが使用できます"
        ])
        #endif
    }
    
    /// デフォルトのプリセットを取得
    /// - Returns: 空の配列（デフォルトプリセットはFirebaseからの取得を優先）
    func getDefaultPresets() -> [ClockPreset] {
        // Firebaseからの取得を優先するためデフォルトのプリセットは空
        return []
    }
    
    /// ウィジェット用にプリセットを読み込む
    func loadPresets() async throws -> [ClockPreset] {
        // 既存のfetchPresetsメソッドの実装を使用
        return try await fetchPresets()
    }
    
    /// 管理者向け機能: プリセットを削除する（通常のユーザーは使用しない）
    func deletePreset(_ preset: ClockPreset) async throws {
        // 既存のdeletePreset(id:)メソッドを使用
        try await deletePreset(id: preset.id)
    }
}
#else
// ダミー実装も不要（WidgetClockPresetRepositoryを使用）
#endif
