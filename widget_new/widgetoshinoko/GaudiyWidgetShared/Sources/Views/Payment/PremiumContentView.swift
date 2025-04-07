import SwiftUI
import GaudiyWidgetShared

// プレミアムコンテンツを表示するための汎用ビュー
struct PremiumContentView<Content: View>: View {
    // コンテンツID（WidgetやWallpaperの一意ID）
    let contentId: String
    // コンテンツタイプ（.widget, .wallpaper, .clockStyle）
    let contentType: PremiumContentType
    // コンテンツ表示用ViewBuilder（購入済みかどうかの状態を渡す）
    let content: (Bool) -> Content
    
    // 内部状態
    @State private var isPurchased: Bool = false
    @State private var isCheckingPurchase: Bool = true
    @State private var showPurchaseSheet: Bool = false
    
    init(
        contentId: String,
        contentType: PremiumContentType,
        @ViewBuilder content: @escaping (Bool) -> Content
    ) {
        self.contentId = contentId
        self.contentType = contentType
        self.content = content
    }
    
    var body: some View {
        ZStack {
            // メインコンテンツ（isPurchasedを引数として渡す）
            content(isPurchased)
            
            // 購入チェック中はローディング表示
            if isCheckingPurchase {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
            }
            
            // 未購入の場合はロックオーバーレイを表示
            if !isPurchased && !isCheckingPurchase {
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text(contentTypeLabel())
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showPurchaseSheet = true
                        }) {
                            Text("購入する")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding(20)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showPurchaseSheet) {
            if let purchasableItem = PremiumContentManager.shared.toPurchasableItem(contentId: contentId) {
                PurchaseConfirmationView(
                    item: purchasableItem,
                    onPurchaseComplete: { success in
                        if success {
                            isPurchased = true
                        }
                        showPurchaseSheet = false
                    }
                )
            } else {
                Text("商品情報の取得に失敗しました")
                    .padding()
            }
        }
        .onAppear {
            checkPurchaseStatus()
        }
    }
    
    // コンテンツタイプに応じたラベルを返す
    private func contentTypeLabel() -> String {
        switch contentType {
        case .widget:
            return "プレミアムウィジェット"
        case .wallpaper:
            return "プレミアム壁紙"
        case .clockStyle:
            return "プレミアム時計スタイル"
        }
    }
    
    // 購入状態をチェック
    private func checkPurchaseStatus() {
        isCheckingPurchase = true
        
        Task {
            let purchased = await PremiumContentManager.shared.isPurchased(contentId: contentId)
            
            // UIの更新はメインスレッドで行う
            DispatchQueue.main.async {
                self.isPurchased = purchased
                self.isCheckingPurchase = false
            }
        }
    }
}
