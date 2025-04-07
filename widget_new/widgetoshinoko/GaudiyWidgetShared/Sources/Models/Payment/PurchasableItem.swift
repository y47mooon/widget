import Foundation

public struct PurchasableItem: Identifiable, Codable {
    public let id: UUID
    public let productId: String
    public let title: String
    public let description: String
    public let price: Decimal
    public let type: PurchaseType
    public var isPurchased: Bool
    
    public enum PurchaseType: String, Codable {
        case widget
        case wallpaper
        case subscription
    }
    
    public init(
        id: UUID = UUID(),
        productId: String,
        title: String,
        description: String,
        price: Decimal,
        type: PurchaseType,
        isPurchased: Bool = false
    ) {
        self.id = id
        self.productId = productId
        self.title = title
        self.description = description
        self.price = price
        self.type = type
        self.isPurchased = isPurchased
    }
}
