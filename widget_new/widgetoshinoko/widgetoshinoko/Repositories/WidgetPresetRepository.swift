import Foundation
import Firebase
import FirebaseFirestore
import GaudiyWidgetShared

// エラー定義
struct NotImplementedError: Error {
    var localizedDescription: String {
        return "この機能は実装されていません"
    }
}

// プロトコル定義
public protocol WidgetPresetRepositoryProtocol {
    func fetchPresets(templateType: WidgetTemplateType) async throws -> [WidgetPreset]
    func fetchPresetsBySize(templateType: WidgetTemplateType, size: WidgetSize) async throws -> [WidgetPreset]
    func loadPresets() async throws -> [WidgetPreset]
}

// Firebase実装
class FirebaseWidgetPresetRepository: WidgetPresetRepositoryProtocol {
    private let db = Firestore.firestore()
    private let collection = "widget_presets"
    
    func fetchPresets(templateType: WidgetTemplateType) async throws -> [WidgetPreset] {
        let snapshot = try await db.collection(collection)
            .whereField("templateType", isEqualTo: templateType.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            convertDocumentToPreset(document)
        }
    }
    
    func fetchPresetsBySize(templateType: WidgetTemplateType, size: WidgetSize) async throws -> [WidgetPreset] {
        let snapshot = try await db.collection(collection)
            .whereField("templateType", isEqualTo: templateType.rawValue)
            .whereField("size", isEqualTo: size.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            convertDocumentToPreset(document)
        }
    }
    
    func loadPresets() async throws -> [WidgetPreset] {
        let snapshot = try await db.collection(collection).getDocuments()
        return snapshot.documents.compactMap { document in
            convertDocumentToPreset(document)
        }
    }
    
    // ドキュメントからPresetへの変換ヘルパーメソッド
    private func convertDocumentToPreset(_ document: QueryDocumentSnapshot) -> WidgetPreset? {
        let data = document.data()
        
        // IDを取得または生成
        let idString = data["id"] as? String ?? document.documentID
        guard let id = UUID(uuidString: idString) else {
            return nil
        }
        
        guard let title = data["title"] as? String,
              let description = data["description"] as? String,
              let typeString = data["type"] as? String,
              let sizeString = data["size"] as? String,
              let style = data["style"] as? String,
              let imageUrl = data["imageUrl"] as? String,
              let requiresPurchase = data["requiresPurchase"] as? Bool else {
            return nil
        }
        
        // オプショナルデータ
        let backgroundColor = data["backgroundColor"] as? String
        let isPurchased = data["isPurchased"] as? Bool ?? false
        
        // 型のパース
        guard let type = WidgetType(rawValue: typeString),
              let size = WidgetSize(rawValue: sizeString) else {
            return nil
        }
        
        // 設定データの抽出
        var configuration: [String: Any] = [:]
        if let configData = data["configuration"] as? [String: Any] {
            configuration = configData
        } else {
            // 個別フィールドから設定情報を収集
            if let textColor = data["textColor"] as? String {
                configuration["textColor"] = textColor
            }
            if let fontSize = data["fontSize"] as? Double {
                configuration["fontSize"] = fontSize
            }
            if let showSeconds = data["showSeconds"] as? Bool {
                configuration["showSeconds"] = showSeconds
            }
        }
        
        return WidgetPreset(
            id: id,
            title: title,
            description: description,
            type: type,
            size: size,
            style: style,
            imageUrl: imageUrl,
            backgroundColor: backgroundColor,
            requiresPurchase: requiresPurchase,
            isPurchased: isPurchased,
            configuration: configuration
        )
    }
}

// モック実装
class MockWidgetPresetRepository: WidgetPresetRepositoryProtocol {
    /// すべてのテンプレートタイプを定義
    private let allTemplateTypes: [WidgetTemplateType] = WidgetTemplateType.allCases
    
    func fetchPresets(templateType: WidgetTemplateType) async throws -> [WidgetPreset] {
        // モックデータを返す
        return createMockPresets(templateType: templateType)
    }
    
    func fetchPresetsBySize(templateType: WidgetTemplateType, size: WidgetSize) async throws -> [WidgetPreset] {
        // サイズでフィルタリングしたモックデータを返す
        return createMockPresets(templateType: templateType)
            .filter { $0.size == size }
    }
    
    func loadPresets() async throws -> [WidgetPreset] {
        // 全てのモックデータを返す
        var allPresets: [WidgetPreset] = []
        
        for templateType in allTemplateTypes {
            allPresets.append(contentsOf: createMockPresets(templateType: templateType))
        }
        
        return allPresets
    }
    
    // モックデータ生成ヘルパーメソッド
    private func createMockPresets(templateType: WidgetTemplateType) -> [WidgetPreset] {
        let sizes: [WidgetSize] = [.small, .medium, .large]
        var presets: [WidgetPreset] = []
        
        // WidgetType.getTypes()を使用して、テンプレートタイプに対応するウィジェットタイプを取得
        let widgetTypes = WidgetType.getTypes(for: templateType)
        
        for size in sizes {
            for widgetType in widgetTypes {
                let backgroundColor = widgetType == .digitalClock ? "#000000" : "#FFFFFF"
                let textColor = widgetType == .digitalClock ? "#FFFFFF" : "#000000"
                
                presets.append(
                    WidgetPreset(
                        id: UUID(),
                        title: "Mock \(widgetType.displayName) (\(size.rawValue))",
                        description: "This is a mock \(widgetType.displayName) preset",
                        type: widgetType,
                        size: size,
                        style: "default",
                        imageUrl: "https://example.com/mock_\(widgetType.rawValue).jpg",
                        backgroundColor: backgroundColor,
                        requiresPurchase: false,
                        isPurchased: true,
                        configuration: [
                            "textColor": textColor,
                            "fontSize": 14.0,
                            "showSeconds": true
                        ]
                    )
                )
            }
        }
        
        return presets
    }
}

