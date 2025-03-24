import SwiftUI

/// デザイン全体で使用する定数を管理する構造体
struct DesignConstants {
    /// レイアウト関連の定数
    struct Layout {
        /// 標準的な余白サイズ
        static let standardPadding: CGFloat = 16
        
        /// アイテム間の標準間隔
        static let standardSpacing: CGFloat = 16
        
        /// アイテム間の小さい間隔
        static let smallSpacing: CGFloat = 8
        
        /// 標準的な角丸半径
        static let cornerRadius: CGFloat = 12
        
        /// ウィジェットリスト表示の高さ
        static let widgetListHeight: CGFloat = 100
    }
    
    /// カラー関連の定数
    struct Colors {
        /// アイテム背景色
        static let itemBackground = Color.gray.opacity(0.2)
        
        /// セカンダリ背景色
        static let secondaryBackground = Color.gray.opacity(0.1)
    }
    
    /// レイアウト計算のためのヘルパー定数
    struct Grid {
        /// ホーム画面での列数
        static let homeColumns: CGFloat = 2
        
        /// リスト画面での列数
        static let listColumns: CGFloat = 2
        
        /// ウィジェット一覧での列数
        static let widgetColumns: CGFloat = 5
        
        /// アイコン表示での列数
        static let iconColumns: CGFloat = 3.5
        
        /// テンプレート表示での列数
        static let templateColumns: CGFloat = 3
    }
}
