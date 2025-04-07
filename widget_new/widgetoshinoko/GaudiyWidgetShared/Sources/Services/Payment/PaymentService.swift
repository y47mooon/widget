import StoreKit

public protocol PaymentServiceProtocol {
    func purchase(_ item: PurchasableItem) async throws
    func verifyPurchase(for productId: String) async throws -> Bool
    func restorePurchases() async throws
    
    // 新しく追加するメソッド
    func loadProducts(ids: [String]) async throws -> [Product]
    var paymentStatus: PaymentStatus { get }
}

public class PaymentService: ObservableObject, PaymentServiceProtocol {
    public static let shared = PaymentService()
    
    // 支払いの状態を追跡
    @Published public private(set) var paymentStatus: PaymentStatus = .notPurchased
    
    // キャッシュされた商品
    private var cachedProducts: [Product] = []
    
    private init() {
        // トランザクションの監視を設定
        setupTransactionListener()
    }
    
    // StoreKit2のトランザクション更新を監視
    private func setupTransactionListener() {
        Task {
            for await verification in Transaction.updates {
                // トランザクションを検証
                switch verification {
                case .verified(let transaction):
                    // 検証済みトランザクションの処理
                    do {
                        try await handlePurchaseSuccess(verification)
                    } catch {
                        // エラー処理（例：ログ出力）
                        print("トランザクション処理エラー: \(error.localizedDescription)")
                    }
                case .unverified:
                    // 検証できないトランザクション
                    break
                }
            }
        }
    }
    
    // 商品情報を読み込む
    public func loadProducts(ids: [String]) async throws -> [Product] {
        do {
            let products = try await Product.products(for: Set(ids))
            self.cachedProducts = products
            return products
        } catch {
            throw PaymentError.productNotFound
        }
    }
    
    public func purchase(_ item: PurchasableItem) async throws {
        // 支払い状態を更新
        DispatchQueue.main.async {
            self.paymentStatus = .purchasing
        }
        
        // 商品が見つからない場合はロード
        if cachedProducts.isEmpty {
            _ = try await loadProducts(ids: [item.productId])
        }
        
        guard let product = cachedProducts.first(where: { $0.id == item.productId }) else {
            DispatchQueue.main.async {
                self.paymentStatus = .failed
            }
            throw PaymentError.productNotFound
        }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // 購入の検証と処理
                try await handlePurchaseSuccess(verification)
            case .userCancelled:
                DispatchQueue.main.async {
                    self.paymentStatus = .notPurchased
                }
                throw PaymentError.cancelled
            case .pending:
                DispatchQueue.main.async {
                    self.paymentStatus = .purchasing
                }
                throw PaymentError.pending
            @unknown default:
                DispatchQueue.main.async {
                    self.paymentStatus = .failed
                }
                throw PaymentError.unknown
            }
        } catch {
            DispatchQueue.main.async {
                self.paymentStatus = .failed
            }
            
            if let paymentError = error as? PaymentError {
                throw paymentError
            } else {
                throw PaymentError.purchaseFailed
            }
        }
    }
    
    // 購入情報をローカルに保存
    private func savePurchaseLocally(_ productId: String) {
        PurchaseStore.shared.savePurchasedItem(productId)
    }
    
    // 商品が購入済みかチェック（ローカル + StoreKit）
    public func isProductPurchased(_ productId: String) async -> Bool {
        // まずローカルのデータをチェック
        if PurchaseStore.shared.isPurchased(productId) {
            return true
        }
        
        // StoreKitで検証（非同期）
        do {
            return try await verifyPurchase(for: productId)
        } catch {
            return false
        }
    }
    
    // 購入検証後のローカル保存処理を追加
    private func handlePurchaseSuccess(_ verification: VerificationResult<Transaction>) async throws {
        switch verification {
        case .verified(let transaction):
            // 購入情報をローカルに保存
            savePurchaseLocally(transaction.productID)
            
            // トランザクションを完了としてマーク
            try await transaction.finish()
            
            DispatchQueue.main.async {
                self.paymentStatus = .purchased
            }
        case .unverified:
            DispatchQueue.main.async {
                self.paymentStatus = .failed
            }
            throw PaymentError.verificationFailed
        }
    }
    
    // 購入検証用の処理を強化
    public func verifyPurchase(for productId: String) async throws -> Bool {
        do {
            // 過去の購入履歴を検証
            var hasValidPurchase = false
            
            // 現在のトランザクションを検証
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result, transaction.productID == productId {
                    hasValidPurchase = true
                    
                    // 購入情報をローカルに保存
                    savePurchaseLocally(productId)
                    break
                }
            }
            
            return hasValidPurchase
        } catch {
            throw PaymentError.verificationFailed
        }
    }
    
    public func restorePurchases() async throws {
        DispatchQueue.main.async {
            self.paymentStatus = .purchasing
        }
        
        do {
            try await AppStore.sync()
            
            // 復元が成功したことを示す
            DispatchQueue.main.async {
                self.paymentStatus = .restored
            }
        } catch {
            DispatchQueue.main.async {
                self.paymentStatus = .failed
            }
            throw PaymentError.restoreFailed
        }
    }
}
