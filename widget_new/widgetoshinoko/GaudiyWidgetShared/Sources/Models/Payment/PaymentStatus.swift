import Foundation

public enum PaymentStatus: String, Codable, CaseIterable {
    case notPurchased = "not_purchased"
    case purchasing = "purchasing"
    case purchased = "purchased"
    case restored = "restored" 
    case failed = "failed"
    case refunded = "refunded"
    
    public var displayName: String {
        switch self {
        case .notPurchased:
            return "未購入"
        case .purchasing:
            return "購入処理中"
        case .purchased:
            return "購入済み"
        case .restored:
            return "復元済み"
        case .failed:
            return "失敗"
        case .refunded:
            return "返金済み"
        }
    }
}
