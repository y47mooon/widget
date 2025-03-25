import WidgetKit
import Foundation

struct ClockEntry: TimelineEntry {
    let date: Date
    
    init(date: Date = Date()) {
        self.date = date
    }
}
