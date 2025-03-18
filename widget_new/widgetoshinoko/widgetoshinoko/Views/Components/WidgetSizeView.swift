import SwiftUI

// ウィジェットアイテムのサイズ表示用コンポーネント
struct WidgetSizeView: View {
    let size: WidgetSize
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: frameHeight)
            .animation(.easeInOut, value: size)
    }
    
    private var frameHeight: CGFloat {
        switch size {
        case .small: return 150
        case .medium: return 200
        case .large: return 250
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
