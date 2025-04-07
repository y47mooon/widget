import Foundation
import Combine
import GaudiyWidgetShared

// お気に入りアイテムのプロトコル
protocol FavoriteItem: Identifiable, Codable {
    var id: UUID { get }
    var title: String { get }
    var contentType: GaudiyContentType { get }
    var imageUrl: String { get }
    var createdAt: Date { get }
}

// お気に入りと統計情報を管理するクラス
class FavoriteManager: ObservableObject {
    // シングルトンインスタンス
    static let shared = FavoriteManager()
    
    // お気に入りリスト
    @Published var favorites: [String: [UUID]] = [:] // contentType: [itemId]
    // 閲覧数の統計
    @Published var viewCounts: [UUID: Int] = [:]
    // ダウンロード数の統計
    @Published var downloadCounts: [UUID: Int] = [:]
    // ダウンロード履歴
    @Published var downloadHistory: [DownloadHistoryItem] = []
    
    // ユーザーデフォルトキー
    private let favoritesKey = "user_favorites"
    private let viewCountsKey = "content_view_counts"
    private let downloadCountsKey = "content_download_counts"
    private let downloadHistoryKey = "download_history"
    
    private init() {
        loadFromUserDefaults()
    }
    
    // UserDefaultsからデータをロード
    private func loadFromUserDefaults() {
        if let favoritesData = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([String: [UUID]].self, from: favoritesData) {
            favorites = decoded
        }
        
        if let viewCountsData = UserDefaults.standard.data(forKey: viewCountsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: viewCountsData) {
            viewCounts = decoded.reduce(into: [UUID: Int]()) { result, pair in
                if let uuid = UUID(uuidString: pair.key) {
                    result[uuid] = pair.value
                }
            }
        }
        
        if let downloadCountsData = UserDefaults.standard.data(forKey: downloadCountsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: downloadCountsData) {
            downloadCounts = decoded.reduce(into: [UUID: Int]()) { result, pair in
                if let uuid = UUID(uuidString: pair.key) {
                    result[uuid] = pair.value
                }
            }
        }
        
        if let historyData = UserDefaults.standard.data(forKey: downloadHistoryKey),
           let decoded = try? JSONDecoder().decode([DownloadHistoryItem].self, from: historyData) {
            downloadHistory = decoded
        }
    }
    
    // UserDefaultsにデータを保存
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
        
        let encodableViewCounts = viewCounts.reduce(into: [String: Int]()) { result, pair in
            result[pair.key.uuidString] = pair.value
        }
        if let encoded = try? JSONEncoder().encode(encodableViewCounts) {
            UserDefaults.standard.set(encoded, forKey: viewCountsKey)
        }
        
        let encodableDownloadCounts = downloadCounts.reduce(into: [String: Int]()) { result, pair in
            result[pair.key.uuidString] = pair.value
        }
        if let encoded = try? JSONEncoder().encode(encodableDownloadCounts) {
            UserDefaults.standard.set(encoded, forKey: downloadCountsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(downloadHistory) {
            UserDefaults.standard.set(encoded, forKey: downloadHistoryKey)
        }
    }
    
    // アイテムをお気に入りに追加/削除
    func toggleFavorite(id: UUID, contentType: GaudiyContentType) {
        let typeKey = contentType.rawValue
        
        // タイプに応じたお気に入りリストを取得または作成
        var typeList = favorites[typeKey] ?? []
        
        if let index = typeList.firstIndex(of: id) {
            // 既にお気に入りなら削除
            typeList.remove(at: index)
        } else {
            // まだお気に入りでなければ追加
            typeList.append(id)
        }
        
        favorites[typeKey] = typeList
        saveToUserDefaults()
    }
    
    // アイテムがお気に入りかどうか確認
    func isFavorite(id: UUID, contentType: GaudiyContentType) -> Bool {
        let typeKey = contentType.rawValue
        guard let typeList = favorites[typeKey] else { return false }
        return typeList.contains(id)
    }
    
    // 特定のタイプのお気に入りをすべて取得
    func getFavorites(contentType: GaudiyContentType) -> [UUID] {
        let typeKey = contentType.rawValue
        return favorites[typeKey] ?? []
    }
    
    // すべてのお気に入りを取得
    func getAllFavorites() -> [UUID] {
        return favorites.values.flatMap { $0 }
    }
    
    // 閲覧数を増やす
    func incrementViewCount(id: UUID) {
        viewCounts[id] = (viewCounts[id] ?? 0) + 1
        saveToUserDefaults()
    }
    
    // 閲覧数を取得
    func getViewCount(id: UUID) -> Int {
        return viewCounts[id] ?? 0
    }
    
    // ダウンロード数を増やす
    func incrementDownloadCount(id: UUID) {
        downloadCounts[id] = (downloadCounts[id] ?? 0) + 1
        saveToUserDefaults()
    }
    
    // ダウンロード数を取得
    func getDownloadCount(id: UUID) -> Int {
        return downloadCounts[id] ?? 0
    }
    
    // ダウンロード履歴に追加
    func addToDownloadHistory(item: DownloadHistoryItem) {
        downloadHistory.insert(item, at: 0) // 最新を先頭に
        saveToUserDefaults()
    }
    
    // ダウンロード履歴を取得
    func getDownloadHistory() -> [DownloadHistoryItem] {
        return downloadHistory
    }
    
    // コンテンツタイプでフィルタリングされたダウンロード履歴を取得
    func getDownloadHistory(contentType: GaudiyContentType) -> [DownloadHistoryItem] {
        return downloadHistory.filter { $0.contentType == contentType }
    }
}

// ダウンロード履歴アイテム
struct DownloadHistoryItem: Identifiable, Codable {
    let id: UUID
    let itemId: UUID
    let title: String
    let imageUrl: String
    let contentType: GaudiyContentType
    let downloadDate: Date
    
    init(itemId: UUID, title: String, imageUrl: String, contentType: GaudiyContentType) {
        self.id = UUID() // 履歴項目自体のID
        self.itemId = itemId // コンテンツアイテムのID
        self.title = title
        self.imageUrl = imageUrl
        self.contentType = contentType
        self.downloadDate = Date()
    }
    
    // Codable対応のためのCodingKeys
    enum CodingKeys: String, CodingKey {
        case id, itemId, title, imageUrl, contentType, downloadDate
    }
    
    // カスタムエンコーディング
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(itemId, forKey: .itemId)
        try container.encode(title, forKey: .title)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(contentType.rawValue, forKey: .contentType)
        try container.encode(downloadDate, forKey: .downloadDate)
    }
    
    // カスタムデコーディング
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        itemId = try container.decode(UUID.self, forKey: .itemId)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let contentTypeRawValue = try container.decode(String.self, forKey: .contentType)
        contentType = GaudiyContentType(rawValue: contentTypeRawValue) ?? .widget // デフォルト値を設定
        downloadDate = try container.decode(Date.self, forKey: .downloadDate)
    }
} 