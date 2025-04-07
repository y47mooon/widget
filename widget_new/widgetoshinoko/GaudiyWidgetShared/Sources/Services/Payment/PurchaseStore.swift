import Foundation

public class PurchaseStore {
    public static let shared = PurchaseStore()
    
    private let userDefaults = UserDefaults.standard
    private let purchasedItemsKey = "com.gaudiy.widget.purchasedItems"
    
    private init() {}
    
    // 購入情報を保存
    public func savePurchasedItem(_ productId: String) {
        var purchasedItems = getPurchasedItems()
        if !purchasedItems.contains(productId) {
            purchasedItems.append(productId)
            userDefaults.set(purchasedItems, forKey: purchasedItemsKey)
        }
    }
    
    // 購入情報を取得
    public func getPurchasedItems() -> [String] {
        return userDefaults.stringArray(forKey: purchasedItemsKey) ?? []
    }
    
    // 購入済みかチェック
    public func isPurchased(_ productId: String) -> Bool {
        return getPurchasedItems().contains(productId)
    }
    
    // 購入情報を削除（テスト用）
    public func removePurchasedItem(_ productId: String) {
        var purchasedItems = getPurchasedItems()
        purchasedItems.removeAll { $0 == productId }
        userDefaults.set(purchasedItems, forKey: purchasedItemsKey)
    }
    
    // 全ての購入情報をクリア（テスト用）
    public func clearAllPurchases() {
        userDefaults.removeObject(forKey: purchasedItemsKey)
    }
}
