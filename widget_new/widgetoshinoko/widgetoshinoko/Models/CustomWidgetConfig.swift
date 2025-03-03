import SwiftUI

struct CustomWidgetConfig: Identifiable, Codable {
    var id = UUID()
    var style: WidgetStyle = .standard
    var color: String = "#000000"
    var imageName: String?
    var fontSize: Double = 14.0
    var cornerRadius: Double = 12.0
    var opacity: Double = 1.0
    var showBorder: Bool = false
    var borderWidth: Double = 1.0
    
    enum WidgetStyle: String, Codable {
        case standard = "スタンダード"
        case minimal = "ミニマル"
        case fancy = "ファンシー"
        case calendar = "カレンダー"
    }
    
    static let defaultConfig = CustomWidgetConfig()
}
