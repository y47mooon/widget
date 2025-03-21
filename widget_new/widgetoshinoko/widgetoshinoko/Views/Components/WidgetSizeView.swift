import SwiftUI


// ウィジェットアイテムのサイズ表示用コンポーネント
struct WidgetSizeView: View {
    let size: WidgetSize
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: calculateWidth(), height: calculateHeight())
            .cornerRadius(12)
    }
    
    private func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 16
        
        switch size {
        case .small:
            // 2列表示
            return (screenWidth - padding - spacing) / 2
        case .medium, .large:
            // 1列表示（画面幅いっぱい）
            return screenWidth - padding
        }
    }
    
    private func calculateHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        switch size {
        case .small:
            // 画面の約1/5の高さ（以前の1/6から調整）
            return screenHeight / 5
        case .medium:
            // 画面の約1/5.5の高さ（以前の1/4から調整）
            return screenHeight / 5.5
        case .large:
            // 画面の約2/5の高さ（以前の1/2から調整）
            return screenHeight * 0.4
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WidgetSizeView(size: .small)
        WidgetSizeView(size: .medium)
        WidgetSizeView(size: .large)
    }
    .padding()
}
