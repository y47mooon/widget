import Foundation

struct ContentItem<Category: CategoryType>: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let imageUrl: String
    let category: Category
    var isFavorite: Bool
    let createdAt: Date
    let popularity: Int
    let requiresPurchase: Bool
    var isPurchased: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        imageUrl: String,
        category: Category,
        isFavorite: Bool = false,
        createdAt: Date = Date(),
        popularity: Int = 0,
        requiresPurchase: Bool = false,
        isPurchased: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.popularity = popularity
        self.requiresPurchase = requiresPurchase
        self.isPurchased = isPurchased
    }
}

// プレビュー用の拡張
extension ContentItem {
    static func preview(category: Category) -> ContentItem<Category> {
        ContentItem(
            title: "サンプルコンテンツ",
            description: "これはサンプルコンテンツの説明です。",
            imageUrl: "content_placeholder",
            category: category,
            popularity: 100,
            requiresPurchase: true
        )
    }
    
    static func freeSample(category: Category) -> ContentItem<Category> {
        ContentItem(
            title: "無料コンテンツ",
            description: "無料で利用できるコンテンツです。",
            imageUrl: "content_placeholder",
            category: category,
            popularity: 80
        )
    }
}
