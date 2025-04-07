import WidgetKit
import Foundation
import GaudiyWidgetShared

struct ClockEntry: TimelineEntry {
    let date: Date
    let configuration: ClockConfiguration?
    let size: WidgetSize
    
    init(date: Date = Date(), configuration: ClockConfiguration? = nil, size: WidgetSize = .small) {
        self.date = date
        self.configuration = configuration
        self.size = size
    }
}
