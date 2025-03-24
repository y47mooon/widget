import SwiftUI

extension View {
    /// 標準的な角丸を適用する
    func standardCornerRadius() -> some View {
        self.cornerRadius(DesignConstants.Layout.cornerRadius)
    }
    
    /// 標準背景色でRectangleを生成
    static func standardRectangle() -> some View {
        Rectangle()
            .fill(DesignConstants.Colors.itemBackground)
    }
    
    /// ウィジェットのサイズに応じたフレームを適用
    func widgetFrame(for size: WidgetSize) -> some View {
        self.frame(
            width: LayoutCalculator.calculateWidgetWidth(for: size),
            height: LayoutCalculator.calculateWidgetHeight(for: size)
        )
    }
    
    /// 表示コンテキストに応じたフレームを適用
    func contextFrame(for context: DisplayContext, isInList: Bool = false) -> some View {
        self.frame(
            width: LayoutCalculator.calculateContentItemWidth(for: context, isInList: isInList),
            height: LayoutCalculator.calculateContentItemHeight(for: context, isInList: isInList)
        )
    }
    
    /// 標準ウィジェットスタイルを適用（角丸と背景色）
    func standardWidgetStyle() -> some View {
        self
            .background(DesignConstants.Colors.itemBackground)
            .cornerRadius(DesignConstants.Layout.cornerRadius)
    }
    
    /// タイトルを持つウィジェットのオーバーレイを適用
    func widgetTitleOverlay(_ title: String) -> some View {
        self.overlay(
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.top, DesignConstants.Layout.smallSpacing)
                    .padding(.leading, DesignConstants.Layout.smallSpacing)
                
                Spacer()
            }
        )
    }
}

// Rectangle特有の拡張
extension Rectangle {
    /// 標準的な背景色で塗りつぶしたRectangle
    static func standardStyle() -> some View {
        Rectangle()
            .fill(DesignConstants.Colors.itemBackground)
            .cornerRadius(DesignConstants.Layout.cornerRadius)
    }
}
