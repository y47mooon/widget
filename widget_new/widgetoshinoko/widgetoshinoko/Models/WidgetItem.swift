import Foundation
import SwiftUI

public struct WidgetItem: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let imageUrl: String
    public let category: String
    public var isFavorite: Bool
    public let popularity: Int
    public let createdAt: Date
    public let requiresPurchase: Bool
    public var isPurchased: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        imageUrl: String,
        category: String,
        isFavorite: Bool = false,
        popularity: Int = 0,
        createdAt: Date = Date(),
        requiresPurchase: Bool = false,
        isPurchased: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.isFavorite = isFavorite
        self.popularity = popularity
        self.createdAt = createdAt
        self.requiresPurchase = requiresPurchase
        self.isPurchased = isPurchased
    }
}

// プレビュー用の拡張
extension WidgetItem {
    public static var previewPurchased: WidgetItem {
        WidgetItem(
            title: "サンプルウィジェット",
            description: "これはサンプルウィジェットです",
            imageUrl: "",
            category: WidgetCategory.weather.rawValue,
            popularity: 100,
            requiresPurchase: true
        )
    }
    
    public static var freeSample: WidgetItem {
        WidgetItem(
            title: "無料ウィジェット",
            description: "これは無料のウィジェットです",
            imageUrl: "",
            category: WidgetCategory.weather.rawValue,
            popularity: 80
        )
    }
}
