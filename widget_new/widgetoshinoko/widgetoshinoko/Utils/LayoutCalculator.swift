import SwiftUI

/// レイアウト計算のためのユーティリティクラス
struct LayoutCalculator {
    
    // MARK: - 基本計算メソッド
    
    /// 基本的なアイテム幅計算（パラメータ化された汎用メソッド）
    static func calculateItemWidth(
        itemCount: CGFloat,
        spacing: CGFloat = DesignConstants.Layout.smallSpacing,
        padding: CGFloat = DesignConstants.Layout.standardPadding * 2
    ) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = spacing * (itemCount - 1)
        return (screenWidth - padding - totalSpacing) / itemCount
    }
    
    // MARK: - ウィジェットサイズ計算
    
    /// ウィジェットサイズに基づく幅計算
    static func calculateWidgetWidth(for size: WidgetSize) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding = DesignConstants.Layout.standardPadding * 2
        let spacing = DesignConstants.Layout.standardSpacing
        
        switch size {
        case .small:
            // 2列表示
            return (screenWidth - padding - spacing) / 2
        case .medium, .large:
            // 1列表示
            return screenWidth - padding
        }
    }
    
    /// ウィジェットサイズに基づく高さ計算
    static func calculateWidgetHeight(for size: WidgetSize) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        switch size {
        case .small:
            return screenHeight / 5
        case .medium:
            return screenHeight / 5.5
        case .large:
            return screenHeight * 0.4
        }
    }
    
    // MARK: - 表示コンテキスト計算
    
    /// 表示コンテキストに基づくアイテム幅計算
    static func calculateContentItemWidth(for context: DisplayContext, isInList: Bool = false) -> CGFloat {
        if isInList {
            // リスト表示時は2列表示で大きめのサイズ
            return calculateItemWidth(
                itemCount: DesignConstants.Grid.listColumns,
                spacing: DesignConstants.Layout.standardSpacing
            )
        } else {
            // ホーム画面表示時は全て3列表示（templateと同じ）
            return calculateItemWidth(
                itemCount: DesignConstants.Grid.templateColumns,
                spacing: DesignConstants.Layout.standardSpacing
            )
        }
    }
    
    /// コンテキストに基づく高さ計算
    static func calculateContentItemHeight(for context: DisplayContext, isInList: Bool = false) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        if isInList {
            // リスト表示時は大きめのサイズ
            return screenHeight * 0.45
        } else {
            // ホーム画面表示時は全て同じ高さ
            return screenHeight * 0.3
        }
    }
    
    // MARK: - グリッド計算
    
    /// 指定されたサイズに基づくグリッド列設定
    static func gridColumns(for size: WidgetSize) -> [GridItem] {
        switch size {
        case .small:
            return [
                GridItem(.flexible(), spacing: DesignConstants.Layout.standardSpacing),
                GridItem(.flexible(), spacing: DesignConstants.Layout.standardSpacing)
            ]
        case .medium, .large:
            return [GridItem(.flexible())]
        }
    }
    
    /// 表示コンテキストに基づくグリッド列設定
    static func gridColumns(for context: DisplayContext) -> [GridItem] {
        let spacing = context == .widget || context == .icon ? 
            DesignConstants.Layout.smallSpacing : 
            DesignConstants.Layout.standardSpacing
        
        switch context {
        case .home, .list:
            return [
                GridItem(.flexible(), spacing: spacing),
                GridItem(.flexible(), spacing: spacing)
            ]
        case .widget:
            // 5列表示のグリッドアイテムを作成
            return Array(repeating: GridItem(.flexible(), spacing: spacing), count: Int(DesignConstants.Grid.widgetColumns))
        case .icon:
            return [
                GridItem(.flexible(), spacing: spacing),
                GridItem(.flexible(), spacing: spacing)
            ]
        case .template:
            return Array(repeating: GridItem(.flexible(), spacing: spacing), count: Int(DesignConstants.Grid.templateColumns))
        }
    }
}
