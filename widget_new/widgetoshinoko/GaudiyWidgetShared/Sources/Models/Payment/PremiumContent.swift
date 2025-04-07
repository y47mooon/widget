import Foundation

// プレミアムコンテンツの種類
public enum PremiumContentType: String, Codable {
    case widget = "widget"
    case wallpaper = "wallpaper"
    case clockStyle = "clock_style"
}

// プレミアムコンテンツを識別するモデル
public struct PremiumContent: Identifiable, Codable {
    public let id: String // プレミアムコンテンツの一意のID
    public let contentId: String // 実際のコンテンツID（ウィジェットIDなど）
    public let productId: String // StoreKitのプロダクトID
    public let type: PremiumContentType
    public let price: Decimal
    
    public init(
        id: String = UUID().uuidString,
        contentId: String,
        productId: String,
        type: PremiumContentType,
        price: Decimal
    ) {
        self.id = id
        self.contentId = contentId
        self.productId = productId
        self.type = type
        self.price = price
    }
}

// プレミアムコンテンツを管理するクラス
public class PremiumContentManager {
    public static let shared = PremiumContentManager()
    
    private var premiumContents: [PremiumContent] = []
    
    private init() {
        // 初期化時にプレミアムコンテンツのリストを設定
        setupPremiumContents()
    }
    
    // プレミアムコンテンツを設定
    private func setupPremiumContents() {
        // 例: プレミアムウィジェット
        premiumContents = [
            PremiumContent(
                contentId: "widget_premium_clock_1",
                productId: "com.gaudiy.widget.premium_clock_1",
                type: .widget,
                price: 480
            ),
            PremiumContent(
                contentId: "wallpaper_premium_1",
                productId: "com.gaudiy.widget.premium_wallpaper_1",
                type: .wallpaper,
                price: 360
            )
            // 他のプレミアムコンテンツを追加
        ]
    }
    
    // コンテンツIDからプレミアムコンテンツ情報を取得
    public func getPremiumContent(forContentId contentId: String) -> PremiumContent? {
        return premiumContents.first { $0.contentId == contentId }
    }
    
    // コンテンツが有料かどうかを判定
    public func isPremiumContent(contentId: String) -> Bool {
        return getPremiumContent(forContentId: contentId) != nil
    }
    
    // コンテンツが購入済みかどうかを判定
    public func isPurchased(contentId: String) async -> Bool {
        guard let premiumContent = getPremiumContent(forContentId: contentId) else {
            // プレミアムコンテンツでなければ購入不要（無料）
            return true
        }
        
        return await PaymentService.shared.isProductPurchased(premiumContent.productId)
    }
    
    // 購入可能なアイテムとして取得
    public func toPurchasableItem(contentId: String) -> PurchasableItem? {
        guard let content = getPremiumContent(forContentId: contentId) else {
            return nil
        }
        
        let type: PurchasableItem.PurchaseType
        switch content.type {
        case .widget:
            type = .widget
        case .wallpaper:
            type = .wallpaper
        case .clockStyle:
            type = .widget
        }
        
        return PurchasableItem(
            productId: content.productId,
            title: "プレミアム\(content.type.rawValue)",
            description: "このプレミアムコンテンツを購入して利用できるようにします",
            price: content.price,
            type: type
        )
    }
}
