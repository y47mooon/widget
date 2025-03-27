import WidgetKit
import Foundation
import GaudiyWidgetShared

struct ClockEntry: TimelineEntry {
    let date: Date
    
    init(date: Date = Date()) {
        self.date = date
    }
}
