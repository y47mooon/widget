import Foundation

public enum GaudiyContentType: String, CaseIterable {
    case template = "template"
    case widget = "widget"
    case icon = "icon"
    case lockScreen = "lockScreen"
    case wallpaper = "wallpaper"
    case movingWallpaper = "movingWallpaper"
    
    public var displayName: String {
        switch self {
        case .template:
            return NSLocalizedString("category_template", comment: "")
        case .widget:
            return NSLocalizedString("category_widget", comment: "")
        case .icon:
            return NSLocalizedString("category_icon", comment: "")
        case .lockScreen:
            return NSLocalizedString("category_lockscreen", comment: "")
        case .wallpaper:
            return NSLocalizedString("category_wallpaper", comment: "")
        case .movingWallpaper:
            return NSLocalizedString("category_moving_wallpaper", comment: "")
        }
    }
}
