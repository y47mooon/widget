import Foundation
import SwiftUI

struct WidgetItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let imageUrl: String
    let category: String
    var isFavorite: Bool
    let popularity: Int
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        imageUrl: String,
        category: String,
        isFavorite: Bool = false,
        popularity: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.isFavorite = isFavorite
        self.popularity = popularity
        self.createdAt = createdAt
    }
}
