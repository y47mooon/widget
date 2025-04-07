import Foundation
import StoreKit

// 課金ステータスの列挙型
enum PurchaseStatus {
    case purchasing
    case purchased
    case failed(Error?)
    case restored
    case deferred
}

protocol PurchaseServiceProtocol {
    func isPurchased(productId: String) -> Bool
    func purchaseProduct(productId: String) async throws -> Bool
    func restorePurchases() async throws
    func fetchAvailableProducts() async throws -> [SKProduct]
}

// テスト用のダミープロダクトID
extension String {
    static let widgetProductPrefix = "com.gaudiy.widgetoshinoko.widget."
    static let wallpaperProductPrefix = "com.gaudiy.widgetoshinoko.wallpaper."
    
    // プロダクトIDを生成するヘルパーメソッド
    static func productId(type: String, id: UUID) -> String {
        return "\(type)\(id.uuidString)"
    }
}

class PurchaseService: NSObject, PurchaseServiceProtocol {
    static let shared = PurchaseService()
    
    private var purchasedProductIds: Set<String> = []
    private var availableProducts: [SKProduct] = []
    private var productsRequest: SKProductsRequest?
    private var completionHandler: ((Result<[SKProduct], Error>) -> Void)?
    
    override init() {
        super.init()
        // 保存されている購入済みアイテムを読み込む
        loadPurchasedProducts()
    }
    
    private func loadPurchasedProducts() {
        if let purchasedIds = UserDefaults.standard.stringArray(forKey: "purchasedProducts") {
            purchasedProductIds = Set(purchasedIds)
        }
    }
    
    private func savePurchasedProducts() {
        UserDefaults.standard.set(Array(purchasedProductIds), forKey: "purchasedProducts")
    }
    
    func isPurchased(productId: String) -> Bool {
        return purchasedProductIds.contains(productId)
    }
    
    func purchaseProduct(productId: String) async throws -> Bool {
        // 実際のStoreKit統合の代わりに、テスト用のモックデータを使用
        // 本番環境では、SKPaymentQueueを使用して実際に課金処理を行う
        
        // テスト用：購入処理をシミュレート
        purchasedProductIds.insert(productId)
        savePurchasedProducts()
        
        // 分析のためにイベントを記録
        AnalyticsService.shared.logEvent("product_purchased", parameters: [
            "product_id": productId
        ])
        
        return true
    }
    
    func restorePurchases() async throws {
        // テスト用：購入の復元をシミュレート
        // 本番環境では、SKPaymentQueue.restoreCompletedTransactionsを呼び出す
    }
    
    func fetchAvailableProducts() async throws -> [SKProduct] {
        // テスト用：利用可能な製品のモックデータを返す
        return availableProducts
    }
    
    // テスト用：ウィジェットを購入済みとしてマーク
    func markWidgetAsPurchased(_ widgetId: UUID) {
        let productId = String.productId(type: .widgetProductPrefix, id: widgetId)
        purchasedProductIds.insert(productId)
        savePurchasedProducts()
    }
    
    // テスト用：壁紙を購入済みとしてマーク
    func markWallpaperAsPurchased(_ wallpaperId: UUID) {
        let productId = String.productId(type: .wallpaperProductPrefix, id: wallpaperId)
        purchasedProductIds.insert(productId)
        savePurchasedProducts()
    }
}
