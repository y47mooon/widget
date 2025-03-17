import SwiftUI

struct WidgetGridView: View {
    let widgets: [WidgetItem]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(widgets) { widget in
                    VStack {
                        // プレースホルダーまたは実際の画像
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .cornerRadius(12)
                        
                        Text(widget.title)
                            .lineLimit(1)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding()
        }
    }
}

// プレビュー用のモックデータがある場合のみ表示
#if DEBUG
#Preview {
    WidgetGridView(widgets: MockData.widgets)
}
#endif
