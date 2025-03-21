import SwiftUI

struct WidgetItemView: View {
    let widget: WidgetItem
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: calculateWidth(), height: 30)  // 高さを80から60に変更
            .cornerRadius(12)
            .overlay(
                VStack(alignment: .leading) {
                    Text(widget.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.top, 8)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
            )
    }
    
    // 横幅を計算するヘルパーメソッド - 5個並ぶようにサイズを調整
    private func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2  // 画面の左右パディング
        let itemCount: CGFloat = 5     // 表示したいアイテム数
        let spacing: CGFloat = 8       // アイテム間の間隔
        let totalSpacing = spacing * (itemCount - 1)  // アイテム間の合計スペース
        
        return (screenWidth - padding - totalSpacing) / itemCount
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
        HStack(spacing: 8) {
            ForEach(0..<5) { index in
                WidgetItemView(widget: WidgetItem.preview)
            }
        }
        .padding()
    }
}
