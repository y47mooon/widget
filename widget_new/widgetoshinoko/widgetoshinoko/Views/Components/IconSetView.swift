import SwiftUI

struct IconSetView: View {
    let iconSet: IconSet
    let maxDisplayIcons: Int = 4
    let isLargeStyle: Bool
    
    init(iconSet: IconSet, isLargeStyle: Bool = false) {
        self.iconSet = iconSet
        self.isLargeStyle = isLargeStyle
    }
    
    var body: some View {
        if isLargeStyle {
            // 単一アイコン表示（外枠なし）
            if let firstIcon = iconSet.icons.first {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: calculateWidth(), height: calculateWidth())
                    .cornerRadius(12)
            }
        } else {
            // 2x2グリッドアイコン表示（外枠あり）
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
                .frame(width: calculateWidth(), height: calculateWidth())
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
}
