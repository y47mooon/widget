import WidgetKit
import Foundation

struct ClockEntry: TimelineEntry {
    let date: Date
    let configuration: ClockConfiguration
}

struct ClockConfiguration: Codable {
    var style: ClockStyle = .digital
    var showSeconds: Bool = false
    var textColor: String = "#000000"  // CustomWidgetConfigと同じように文字列で色を保持
    var fontSize: Double = 14.0
    
    enum ClockStyle: String, Codable {
        case digital    // デジタル表示
        case analog     // アナログ表示
        case minimal    // ミニマル表示
    }
}
