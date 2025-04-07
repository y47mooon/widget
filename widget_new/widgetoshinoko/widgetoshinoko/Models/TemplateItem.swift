import Foundation
import GaudiyWidgetShared

// GaudiyWidgetSharedで定義したTemplateBaseを継承
struct TemplateItem: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let imageUrl: String
    let category: TemplateCategory
    let popularity: Int
    let createdAt: Date
    
    // TemplateBaseからの初期化用コンストラクタ
    init(from base: TemplateBase) {
        self.id = base.id
        self.title = base.title
        self.description = base.description
        self.imageUrl = base.imageUrl
        self.category = base.category
        self.popularity = base.popularity
        self.createdAt = base.createdAt
    }
    
    // 通常のコンストラクタ
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        imageUrl: String,
        category: TemplateCategory = .popular,
        popularity: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.popularity = popularity
        self.createdAt = createdAt
    }
    
    // TemplateBaseに変換するメソッド
    func toTemplateBase() -> TemplateBase {
        return TemplateBase(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl,
            category: category,
            popularity: popularity,
            createdAt: createdAt
        )
    }
} 