import SwiftUI


// ウィジェットアイテムのサイズ表示用コンポーネント
struct WidgetSizeView: View {
    let size: WidgetSize
    let title: String?
    
    init(size: WidgetSize, title: String? = nil) {
        self.size = size
        self.title = title
    }
    
    var body: some View {
        if let title = title {
            Rectangle.standardStyle()
                .widgetFrame(for: size)
                .widgetTitleOverlay(title)
        } else {
            Rectangle.standardStyle()
                .widgetFrame(for: size)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WidgetSizeView(size: .small, title: "Small Widget")
        WidgetSizeView(size: .medium, title: "Medium Widget")
        WidgetSizeView(size: .large)
    }
    .padding()
}
