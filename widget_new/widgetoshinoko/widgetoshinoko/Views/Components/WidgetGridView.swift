import SwiftUI

struct WidgetGridView: View {
    let widgets: [WidgetItem]
    let selectedSize: WidgetSize
    
    var columns: [GridItem] {
        switch selectedSize {
        case .small:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .medium, .large:
            return [GridItem(.flexible())]
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(widgets, id: \.id) { widget in
                WidgetSizeView(size: selectedSize)
            }
        }
        .padding()
    }
}

// プレビュー用のモックデータがある場合のみ表示
#if DEBUG
#Preview {
    WidgetGridView(widgets: MockData.widgets, selectedSize: .small)
}
#endif
