import Foundation
import GaudiyWidgetShared

/// ダウンロード履歴アイテムの構造体
public struct DownloadHistoryItem: Identifiable, Codable {
    public let id: UUID
    public let itemId: UUID
    public let title: String
    public let imageUrl: String
    public let contentType: GaudiyContentType
    public let downloadDate: Date
    
    public init(
        id: UUID = UUID(),
        itemId: UUID,
        title: String,
        imageUrl: String,
        contentType: GaudiyContentType,
        downloadDate: Date = Date()
    ) {
        self.id = id
        self.itemId = itemId
        self.title = title
        self.imageUrl = imageUrl
        self.contentType = contentType
        self.downloadDate = downloadDate
    }
    
    // Codable対応のためのCodingKeys
    private enum CodingKeys: String, CodingKey {
        case id, itemId, title, imageUrl, contentType, downloadDate
    }
    
    // カスタムエンコーディング
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(itemId, forKey: .itemId)
        try container.encode(title, forKey: .title)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(contentType.rawValue, forKey: .contentType)
        try container.encode(downloadDate, forKey: .downloadDate)
    }
    
    // カスタムデコーディング
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        itemId = try container.decode(UUID.self, forKey: .itemId)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let contentTypeRawValue = try container.decode(String.self, forKey: .contentType)
        contentType = GaudiyContentType(rawValue: contentTypeRawValue) ?? .widget // デフォルト値を設定
        downloadDate = try container.decode(Date.self, forKey: .downloadDate)
    }
} 