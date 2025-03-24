import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case serverError(Int)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .invalidResponse:
            return "サーバーからの応答が無効です"
        case .networkError(let error):
            return "通信エラー: \(error.localizedDescription)"
        case .serverError(let code):
            return "サーバーエラー: \(code)"
        }
    }
}
