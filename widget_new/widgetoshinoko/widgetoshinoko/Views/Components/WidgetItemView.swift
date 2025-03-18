import SwiftUI

struct WidgetItemView: View {
    let widget: WidgetItem
    var displayStyle: WidgetDisplayStyle = .standard
    var height: CGFloat = 80
    
    var body: some View {
        switch displayStyle {
        case .standard:
            standardWidget
        case .rectangular:
            rectangularWidget
        case .square:
            squareWidget
        case .mixed(let index):
            // 混合表示（インデックスに基づく）
            if index % 2 == 0 {
                rectangularWidget
            } else {
                squareWidget
            }
        }
    }
    
    // 標準的なウィジェット表示（現在の実装を保持）
    private var standardWidget: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: calculateWidth(), height: height)
            .cornerRadius(12)
            .overlay(
                VStack(alignment: .leading) {
                    Text(widget.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
            )
    }
    
    // 長方形ウィジェット（横長）
    private var rectangularWidget: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: calculateWidth(), height: 80)
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
    
    // 正方形ウィジェット（アイコンサイズ）
    private var squareWidget: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 80, height: 80)
            .cornerRadius(12)
            .overlay(
                VStack(alignment: .center) {
                    Text(widget.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                    
                    Spacer()
                }
            )
    }
    
    // 横幅を計算するヘルパーメソッドを追加
    private func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2  // 画面の左右パディング
        let spacing: CGFloat = 8 * 2   // アイテム間のスペース
        let itemCount: CGFloat = 2     // 1行に表示するアイテム数
        
        return (screenWidth - padding - spacing) / itemCount
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
    VStack(spacing: 20) {
        HStack(spacing: 10) {
            WidgetItemView(widget: WidgetItem.preview, displayStyle: .rectangular)
            WidgetItemView(widget: WidgetItem.preview, displayStyle: .square)
        }
        
        WidgetItemView(widget: WidgetItem.preview, displayStyle: .standard)
        
        HStack(spacing: 10) {
            WidgetItemView(widget: WidgetItem.preview, displayStyle: .mixed(index: 0))
            WidgetItemView(widget: WidgetItem.preview, displayStyle: .mixed(index: 1))
        }
    }
    .padding()
}
