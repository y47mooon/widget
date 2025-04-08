import Foundation
import GaudiyWidgetShared
// モデルをインポート

/// ダウンロード履歴を管理するクラス
class DownloadHistoryManager: ObservableObject {
    static let shared = DownloadHistoryManager()
    
    @Published private(set) var historyItems: [DownloadHistoryItem] = []
    
    private let historyKey = "download_history_items"
    private let maxHistoryItems = 100 // 履歴の最大保存数
    
    private init() {
        loadHistory()
    }
    
    /// 履歴をUserDefaultsから読み込む
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey) {
            do {
                let decoder = JSONDecoder()
                historyItems = try decoder.decode([DownloadHistoryItem].self, from: data)
            } catch {
                print("履歴の読み込みに失敗しました: \(error)")
                historyItems = []
            }
        }
    }
    
    /// 履歴をUserDefaultsに保存する
    private func saveHistory() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(historyItems)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("履歴の保存に失敗しました: \(error)")
        }
    }
    
    /// 履歴に新しいアイテムを追加する
    func addToHistory(_ item: DownloadHistoryItem) {
        // 既に同じitemIdがある場合は削除（重複を避ける）
        historyItems.removeAll { $0.itemId == item.itemId && $0.contentType == item.contentType }
        
        // 新しい履歴を先頭に追加
        historyItems.insert(item, at: 0)
        
        // 最大保存数を超えた場合、古いものから削除
        if historyItems.count > maxHistoryItems {
            historyItems = Array(historyItems.prefix(maxHistoryItems))
        }
        
        // 変更を保存
        saveHistory()
    }
    
    /// 特定のコンテンツタイプの履歴を取得する
    func getHistory(for contentType: GaudiyContentType? = nil) -> [DownloadHistoryItem] {
        if let type = contentType {
            return historyItems.filter { $0.contentType == type }
        } else {
            return historyItems
        }
    }
    
    /// 特定の履歴アイテムを削除
    func removeFromHistory(id: UUID) {
        historyItems.removeAll { $0.id == id }
        saveHistory()
    }
    
    /// 履歴をすべて削除
    func clearHistory() {
        historyItems.removeAll()
        saveHistory()
    }
} 