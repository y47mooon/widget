import SwiftUI

/// アプリ全体のテーマ設定を管理する構造体
struct AppTheme {
    // 色
    static let primaryColor = Color.pink
    static let secondaryColor = Color.gray
    static let backgroundColor = Color.white
    static let accentColor = Color.blue
    
    // フォント
    static let titleFont = Font.headline
    static let bodyFont = Font.body
    static let smallFont = Font.system(size: 14)
    
    // サイズ
    static let cornerRadius: CGFloat = 12
    static let standardPadding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    // アニメーション
    static let standardAnimation = Animation.easeInOut(duration: 0.2)
    
    // スタイル
    struct CardStyle {
        let backgroundColor: Color
        let foregroundColor: Color
        let cornerRadius: CGFloat
        
        static let standard = CardStyle(
            backgroundColor: Color.white,
            foregroundColor: Color.black,
            cornerRadius: 12
        )
        
        static let highlighted = CardStyle(
            backgroundColor: primaryColor.opacity(0.1),
            foregroundColor: primaryColor,
            cornerRadius: 12
        )
    }
}

// テーマを適用するためのモディファイア
extension View {
    func applyCardStyle(_ style: AppTheme.CardStyle) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
            )
            .foregroundColor(style.foregroundColor)
    }
}
