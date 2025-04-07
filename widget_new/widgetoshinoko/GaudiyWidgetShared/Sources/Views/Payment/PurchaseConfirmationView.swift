import SwiftUI

public struct PurchaseConfirmationView: View {
    let item: PurchasableItem
    let onPurchaseComplete: (Bool) -> Void
    
    @StateObject private var paymentService = PaymentService.shared
    @State private var isPurchasing = false
    @State private var errorMessage: String? = nil
    @State private var showError = false
    
    public init(
        item: PurchasableItem,
        onPurchaseComplete: @escaping (Bool) -> Void
    ) {
        self.item = item
        self.onPurchaseComplete = onPurchaseComplete
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text(item.title)
                .font(.headline)
            
            Text(item.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Text("\(item.price)")
                .font(.title)
            
            VStack(spacing: 12) {
                Button {
                    Task {
                        await performPurchase()
                    }
                } label: {
                    HStack {
                        if isPurchasing {
                            ProgressView()
                                .padding(.trailing, 5)
                        }
                        
                        Text("購入する")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(isPurchasing)
                
                Button {
                    Task {
                        await performRestore()
                    }
                } label: {
                    Text("購入を復元")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .disabled(isPurchasing)
                
                Button {
                    onPurchaseComplete(false)
                } label: {
                    Text("キャンセル")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .disabled(isPurchasing)
            }
        }
        .padding()
        .alert("エラー", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            if let message = errorMessage {
                Text(message)
            }
        }
        .onChange(of: paymentService.paymentStatus) { newValue in
            if newValue == .purchased || newValue == .restored {
                onPurchaseComplete(true)
            }
        }
    }
    
    private func performPurchase() async {
        isPurchasing = true
        
        do {
            try await PaymentService.shared.purchase(item)
            // onChangeでハンドリング
        } catch let paymentError as PaymentError {
            errorMessage = paymentError.localizedDescription
            showError = true
            isPurchasing = false
        } catch {
            errorMessage = "不明なエラーが発生しました"
            showError = true
            isPurchasing = false
        }
    }
    
    private func performRestore() async {
        isPurchasing = true
        
        do {
            try await PaymentService.shared.restorePurchases()
            // 復元後に購入済みアイテムを検証
            let isVerified = try await PaymentService.shared.verifyPurchase(for: item.productId)
            if !isVerified {
                errorMessage = "この商品の購入履歴が見つかりませんでした"
                showError = true
                isPurchasing = false
            }
            // 検証成功時はonChangeでハンドリング
        } catch {
            errorMessage = "購入の復元に失敗しました"
            showError = true
            isPurchasing = false
        }
    }
}

