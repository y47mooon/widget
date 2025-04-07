import Foundation

public enum PaymentError: LocalizedError {
    case productNotFound
    case purchaseFailed
    case notAuthorized
    case networkError
    case verificationFailed
    case cancelled
    case pending
    case restoreFailed
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "商品が見つかりませんでした"
        case .purchaseFailed:
            return "購入に失敗しました"
        case .notAuthorized:
            return "購入が許可されていません"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .verificationFailed:
            return "購入の検証に失敗しました"
        case .cancelled:
            return "購入がキャンセルされました"
        case .pending:
            return "購入処理が保留中です"
        case .restoreFailed:
            return "購入の復元に失敗しました"
        case .unknown:
            return "不明なエラーが発生しました"
        }
    }
}
