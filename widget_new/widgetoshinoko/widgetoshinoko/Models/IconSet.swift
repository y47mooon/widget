import Foundation // UUID, Dateのために必要
import GaudiyWidgetShared

/// アイコンセットのモデル
struct IconSet: Identifiable {
    let id: UUID
    let title: String
    let icons: [Icon]
    let category: IconCategory
    let popularity: Int
    let createdAt: Date
    /// プレビュー用URL（サムネイル等に使用）
    let previewUrl: String
    
    /// 初期化メソッド
    init(
        id: UUID = UUID(),
        title: String,
        icons: [Icon] = [],
        category: IconCategory = .popular,
        createdAt: Date = Date(),
        popularity: Int = 0,
        previewUrl: String = ""
    ) {
        self.id = id
        self.title = title
        self.icons = icons
        self.category = category
        self.popularity = popularity
        self.createdAt = createdAt
        // アイコンの最初の画像がある場合はそれをプレビュー画像として使用
        self.previewUrl = previewUrl.isEmpty && !icons.isEmpty ? icons[0].imageUrl : previewUrl
    }
    
    /// アイコン情報
    struct Icon: Identifiable {
        let id: UUID
        let imageUrl: String
        let targetAppBundleId: String? // 設定対象のアプリのバンドルID
        
        init(
            id: UUID = UUID(),
            imageUrl: String,
            targetAppBundleId: String? = nil
        ) {
            self.id = id
            self.imageUrl = imageUrl
            self.targetAppBundleId = targetAppBundleId
        }
    }
    
    /// シンプルなプレビュー用のアイコンセットを作成
    static func previewOnly(id: UUID = UUID(), title: String, previewUrl: String) -> IconSet {
        return IconSet(
            id: id,
            title: title,
            icons: [],
            previewUrl: previewUrl
        )
    }
}

// ContentItemに変換するための拡張
extension IconSet {
    func toContentItem() -> ContentItem<IconCategory> {
        let imageUrl = previewUrl.isEmpty && !icons.isEmpty ? icons[0].imageUrl : previewUrl
        
        return ContentItem(
            id: id,
            title: title,
            description: "",
            imageUrl: imageUrl,
            category: category,
            isFavorite: false,
            createdAt: createdAt,
            popularity: popularity
        )
    }
    
    static func from(contentItem: ContentItem<IconCategory>) -> IconSet {
        return IconSet(
            id: contentItem.id,
            title: contentItem.title,
            category: contentItem.category,
            createdAt: contentItem.createdAt,
            popularity: contentItem.popularity,
            previewUrl: contentItem.imageUrl
        )
    }
}
