import Foundation
import FirebaseFirestoreSwift

struct Payment: Identifiable, Codable {
    @DocumentID var id: String?
    var uuid = UUID()
    var userId: String
    var paymentStatus: String
    var paymentMethod: String
    var storeTransactionId: String?
    var amount: Double
    var currency: String = "JPY"
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case userId = "user_id"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case storeTransactionId = "store_transaction_id"
        case amount
        case currency
        case createdAt = "created_at"
    }
}
