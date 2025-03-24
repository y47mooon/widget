import SwiftUI
import WidgetKit
import AppIntents

// まず、ウィジェットに表示する情報の型を決めます
struct SimpleEntry: TimelineEntry {
    let date: Date                                  // 日付
    let configuration: ConfigurationAppIntent       // 設定情報
}

// 次に、その情報を提供する「Provider」を作ります
struct Provider: TimelineProvider {
    // 3つの基本機能を実装します
    
    // その1：読み込み中の表示
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }
    
    // その2：プレビューの表示
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
        completion(entry)
    }
    
    // その3：実際のウィジェット表示
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct gaudiyoshinokoEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch family {
                case .systemSmall:
                    Image("WidgetBackgroundSmall")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width + 20, height: geometry.size.height + 20)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                case .systemMedium:
                    Image("WidgetBackgroundMedium")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width + 20, height: geometry.size.height + 20)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                case .systemLarge:
                    Image("WidgetBackgroundLarge")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width + 20, height: geometry.size.height + 20)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                default:
                    Image("WidgetBackgroundSmall")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width + 20, height: geometry.size.height + 20)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                }
            }
            .clipped()
        }
    }
}

struct gaudiyoshinoko: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "gaudiyoshinoko",
            provider: Provider()
        ) { entry in
            gaudiyoshinokoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([
            .systemSmall,    // 小サイズ
            .systemMedium,   // 中サイズ
            .systemLarge     // 大サイズ
        ])
    }
}
