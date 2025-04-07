import Foundation

public struct Payment: Identifiable, Codable {
    public let id: UUID
    public let userId: String
    public let productId: String
    public let amount: Double
    public let currency: String
    public let status: PaymentStatus
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        userId: String,
        productId: String,
        amount: Double,
        currency: String = "JPY",
        status: PaymentStatus = .purchased,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.productId = productId
        self.amount = amount
        self.currency = currency
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
