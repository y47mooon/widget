import WidgetKit
import Foundation

struct ClockWidgetProvider: TimelineProvider {
    // アプリグループIDをハードコード
    private let userDefaults = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")!
    
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        let entry = ClockEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        
        let entry = ClockEntry(date: currentDate)
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}
