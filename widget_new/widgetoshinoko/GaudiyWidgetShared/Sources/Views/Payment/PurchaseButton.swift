import SwiftUI

public struct PurchaseButton: View {
    let title: String
    let action: () -> Void
    let isPurchasing: Bool
    
    public init(
        title: String = "購入する",
        isPurchasing: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isPurchasing = isPurchasing
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(isPurchasing)
    }
}
