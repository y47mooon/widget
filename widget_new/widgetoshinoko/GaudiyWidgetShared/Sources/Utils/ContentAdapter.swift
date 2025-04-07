import Foundation

public class ContentAdapter {
    public static func toContent(_ item: FirebaseContentItem) -> Content? {
        Logger.shared.debug("Converting item: \(item.id)")
        let data = item.data
        
        // データの取得
        guard let description = data["description"]?.value as? String,
              let thumbnailImageName = data["thumbnailImageName"]?.value as? String,
              let previewImageUrl = data["previewImageUrl"]?.value as? String,
              let createdBy = data["createdBy"]?.value as? String,
              let updatedBy = data["updatedBy"]?.value as? String else {
            return nil
        }
        
        // オプショナルな値の取得（デフォルト値を設定）
        let isPublic = data["isPublic"]?.value as? Bool ?? true
        let isFavorite = data["isFavorite"]?.value as? Bool ?? false
        let popularity = data["popularity"]?.value as? Int ?? 0
        let status = data["status"]?.value as? String ?? "active"
        let displayOrder = data["displayOrder"]?.value as? Int ?? 0
        let tags = data["tags"]?.value as? [String] ?? []
        
        // 設定データの取得
        let configData = data["configuration"]?.value as? [String: Any] ?? [:]
        let style = configData["style"] as? String ?? "default"
        let editableFields = configData["editableFields"] as? [String] ?? []
        
        // 日付の取得（デフォルトは現在時刻）
        let createdAt = (data["createdAt"]?.value as? Date) ?? Date()
        let updatedAt = (data["updatedAt"]?.value as? Date) ?? Date()
        
        let content = Content(
            id: item.id,
            description: description,
            category: item.contentType,
            isPublic: isPublic,
            isFavorite: isFavorite,
            popularity: popularity,
            status: status,
            displayOrder: displayOrder,
            tags: tags,
            thumbnailImageName: thumbnailImageName,
            previewImageUrl: previewImageUrl,
            configuration: ContentConfiguration(
                style: style,
                editableFields: editableFields
            ),
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy
        )
        
        Logger.shared.info("Successfully converted to Content")
        return content
    }
    
    public static func toFirebaseContentItem(_ content: Content) -> FirebaseContentItem {
        let data: [String: Any] = [
            "description": content.description,
            "isPublic": content.isPublic,
            "isFavorite": content.isFavorite,
            "popularity": content.popularity,
            "status": content.status,
            "displayOrder": content.displayOrder,
            "tags": content.tags,
            "thumbnailImageName": content.thumbnailImageName,
            "previewImageUrl": content.previewImageUrl,
            "configuration": [
                "style": content.configuration.style,
                "editableFields": content.configuration.editableFields
            ],
            "createdAt": content.createdAt,
            "updatedAt": content.updatedAt,
            "createdBy": content.createdBy,
            "updatedBy": content.updatedBy
        ]
        
        return FirebaseContentItem(
            id: content.id,
            type: "content",
            contentType: content.category,
            data: data
        )
    }
}
