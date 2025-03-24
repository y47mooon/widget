import SwiftUI

struct WidgetItemView: View {
    let widget: WidgetItem
    
    var body: some View {
        Rectangle.standardStyle()
            .contextFrame(for: .widget)
            .widgetTitleOverlay(widget.title)
    }
}

// ウィジェット表示スタイルの列挙型
enum WidgetDisplayStyle {
    case standard    // 標準表示（既存の実装）
    case rectangular // 長方形（横長）
    case square      // 正方形（アイコンサイズ）
    case mixed(index: Int) // 混合表示（インデックスに基づく交互表示）
}

#Preview {
    ScrollView(.horizontal) {
        HStack(spacing: DesignConstants.Layout.smallSpacing) {
            ForEach(0..<5) { index in
                WidgetItemView(widget: WidgetItem.preview)
            }
        }
        .padding()
    }
}
