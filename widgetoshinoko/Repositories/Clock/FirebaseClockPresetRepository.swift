import Foundation
import FirebaseFirestore

protocol ClockPresetRepository {
    func fetchPresets() async throws -> [ClockPreset]
    func savePreset(_ preset: ClockPreset) async throws
    func updatePreset(_ preset: ClockPreset) async throws
    func deletePreset(_ id: UUID) async throws
    
    // 新しいメソッド：デフォルトプリセットの取得
    func getDefaultPresets() -> [ClockPreset]
}

class FirebaseClockPresetRepository: ClockPresetRepository {
    private let db = Firestore.firestore()
    private let collection = "clock_presets"
    
    func fetchPresets() async throws -> [ClockPreset] {
        let snapshot = try await db.collection(collection).getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: ClockPreset.self)
        }
    }
    
    func savePreset(_ preset: ClockPreset) async throws {
        let documentRef = db.collection(collection).document(preset.id.uuidString)
        try documentRef.setData(from: preset)
    }
    
    func updatePreset(_ preset: ClockPreset) async throws {
        let documentRef = db.collection(collection).document(preset.id.uuidString)
        try documentRef.setData(from: preset, merge: true)
    }
    
    func deletePreset(_ id: UUID) async throws {
        try await db.collection(collection).document(id.uuidString).delete()
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
