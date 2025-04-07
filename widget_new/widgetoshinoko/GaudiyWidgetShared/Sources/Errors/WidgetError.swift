import Foundation
import WidgetKit

public enum WidgetError: LocalizedError, Identifiable {
    case fetchFailed(Error)
    case saveFailed(Error)
    case invalidConfiguration(String)
    case purchaseRequired
    case networkError(Error)
    case unauthorized
    case limitExceeded
    
    public var id: String { errorDescription ?? "" }
    
    public var errorDescription: String? {
        switch self {
        case .fetchFailed(let error):
            return "ウィジェットの取得に失敗しました: \(error.localizedDescription)"
        case .saveFailed(let error):
            return "ウィジェットの保存に失敗しました: \(error.localizedDescription)"
        case .invalidConfiguration(let reason):
            return "無効な設定です: \(reason)"
        case .purchaseRequired:
            return "このウィジェットは購入が必要です"
        case .networkError(let error):
            return "ネットワークエラー: \(error.localizedDescription)"
        case .unauthorized:
            return "認証が必要です"
        case .limitExceeded:
            return "ウィジェットの上限（20個）に達しました"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .fetchFailed, .saveFailed:
            return "もう一度お試しください"
        case .networkError:
            return "インターネット接続を確認してください"
        case .unauthorized:
            return "ログインが必要です"
        case .purchaseRequired:
            return "購入して機能を利用できます"
        case .invalidConfiguration:
            return "設定を見直してください"
        case .limitExceeded:
            return "不要なウィジェットを削除してください"
        }
    }
}
