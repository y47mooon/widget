import SwiftUI
import GaudiyWidgetShared

/// レイアウト計算のためのユーティリティクラス
public struct LayoutCalculator {
    
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
            return [GridItem(.adaptive(minimum: 100), spacing: 16)]
        case .medium:
            return [GridItem(.adaptive(minimum: 150), spacing: 16)]
        case .large:
            return [GridItem(.adaptive(minimum: 300), spacing: 16)]
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
    
    // MARK: - デバイスタイプ判定
    
    static var isSmallDevice: Bool {
        return UIScreen.main.bounds.width < 375 // iPhone SEなどの小型デバイス
    }
    
    static var isLargeDevice: Bool {
        return UIScreen.main.bounds.width >= 428 // iPhone Pro Maxなどの大型デバイス
    }
    
    // MARK: - デバイスサイズに応じて列数を調整
    
    static func adjustedColumnCount(baseCount: CGFloat) -> CGFloat {
        if isSmallDevice {
            return max(baseCount - 1, 1) // 小型デバイスでは列数を減らす
        } else if isLargeDevice {
            return baseCount + 1 // 大型デバイスでは列数を増やす
        }
        return baseCount
    }
    
    // MARK: - 向きの検出と対応
    
    static var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    // MARK: - 向きに応じたグリッド列の調整
    
    static func gridColumnsForOrientation(for context: DisplayContext) -> [GridItem] {
        if isLandscape {
            // 横向きの場合は列数を増やす
            let extraColumns: Int = context == .template ? 2 : 1
            let baseCount = Int(DesignConstants.Grid.templateColumns) + extraColumns
            return Array(repeating: GridItem(.flexible(), spacing: DesignConstants.Layout.smallSpacing), count: baseCount)
        } else {
            return gridColumns(for: context)
        }
    }
    
    public static func itemWidth(for size: WidgetSize) -> CGFloat {
        switch size {
        case .small: return 100
        case .medium: return 150
        case .large: return 300
        }
    }
    
    public static func itemHeight(for size: WidgetSize) -> CGFloat {
        switch size {
        case .small: return 100
        case .medium: return 150
        case .large: return 300
        }
    }
}
