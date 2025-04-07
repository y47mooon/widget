import SwiftUI

struct IconSetView: View {
    let iconSet: IconSet
    let maxDisplayIcons: Int = 4
    let isLargeStyle: Bool
    let isInList: Bool
    
    init(iconSet: IconSet, isLargeStyle: Bool = false, isInList: Bool = false) {
        self.iconSet = iconSet
        self.isLargeStyle = isLargeStyle
        self.isInList = isInList
    }
    
    var body: some View {
        if isLargeStyle {
            // 単一アイコン表示（外枠なし）
            if let firstIcon = iconSet.icons.first {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: itemWidth, height: itemWidth)
                    .cornerRadius(12)
            }
        } else if isInList {
            // もっと見る展開後のレイアウト
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(iconSet.icons.prefix(2), id: \.id) { icon in
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(4)
                    }
                }
                HStack(spacing: 0) {
                    ForEach(iconSet.icons.dropFirst(2).prefix(2), id: \.id) { icon in
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(4)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        } else {
            // 展開前のレイアウト（元のまま）
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 8),
                            GridItem(.flexible(), spacing: 8)
                        ],
                        spacing: 8
                    ) {
                        ForEach(iconSet.icons.prefix(maxDisplayIcons)) { icon in
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(12)
                        }
                    }
                    .padding(8)
                )
                .frame(width: itemWidth, height: itemHeight)
        }
    }
    
    private func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 8
        let itemCount: CGFloat = 3.5 // 表示数を統一
        let totalSpacing = spacing * (itemCount - 1)
        
        return (screenWidth - padding - totalSpacing) / itemCount
    }
    
    private var itemWidth: CGFloat {
        if isInList {
            // リスト表示時のサイズ（ContentItemViewと同じ計算方法）
            let screenWidth = UIScreen.main.bounds.width
            let padding: CGFloat = 16 * 2
            let spacing: CGFloat = 16
            return (screenWidth - padding - spacing) / 2
        } else {
            // ホーム表示時のサイズ（既存の計算方法）
            return calculateWidth()
        }
    }
    
    private var itemHeight: CGFloat {
        isInList ? UIScreen.main.bounds.height * 0.45 : itemWidth
    }
}
