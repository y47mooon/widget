import Foundation

enum WidgetCreationType: String, CaseIterable, Identifiable {
    case widget = "ウィジェット"
    case icon = "アイコン"
    case template = "テンプレート"
    case lockScreen = "ロック画面"
    case liveWallpaper = "ライブ壁紙"
    case cancel = "キャンセル"
    
    var id: String { self.rawValue }
}