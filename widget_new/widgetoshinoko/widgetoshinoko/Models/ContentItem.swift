import Foundation

struct ContentItem<Category: CategoryType>: Identifiable {
    let id: UUID
    let title: String
    let imageUrl: String
    let category: Category
    var isFavorite: Bool
    let createdAt: Date
    let popularity: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        imageUrl: String,
        category: Category,
        isFavorite: Bool = false,
        createdAt: Date = Date(),
        popularity: Int = 0
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.category = category
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.popularity = popularity
    }
}
