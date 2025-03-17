import SwiftUI
import WidgetKit
import AppIntents

// Providerの定義を追加
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        return Timeline(entries: [entry], policy: .never)
    }
}

// SimpleEntryの定義を追加
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
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
    let kind: String = "gaudiyoshinoko"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            gaudiyoshinokoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])  // 必要なサイズのみ指定
        .contentMarginsDisabled()  // パフォーマンス向上のため
    }
}
