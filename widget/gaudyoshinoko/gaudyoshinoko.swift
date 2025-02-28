//
//  gaudyoshinoko.swift
//  gaudyoshinoko
//
//  Created by ゆぅ on 2025/02/26.
//

import WidgetKit
import SwiftUI

enum WidgetTheme: String, Codable, CaseIterable {
    case light
    case dark
    case pink
    case blue
    case purple
    
    var backgroundColor: Color {
        switch self {
        case .light: return Color(.systemBackground)
        case .dark: return Color(.systemGray6)
        case .pink: return Color(red: 255/255, green: 192/255, blue: 203/255)
        case .blue: return Color(red: 173/255, green: 216/255, blue: 230/255)
        case .purple: return Color(red: 221/255, green: 160/255, blue: 221/255)
        }
    }
    
    var textColor: Color {
        switch self {
        case .light, .pink, .blue, .purple: return .black
        case .dark: return .white
        }
    }
}

enum WidgetStyle: String, Codable, CaseIterable {
    case standard
    case minimal
    case fancy
    case calendar
}

struct WidgetData: Codable {
    var userName: String
    var points: Int
    var lastUpdated: Date
    var theme: WidgetTheme
    var style: WidgetStyle
    var showPoints: Bool
    var showDate: Bool
    
    static let defaultData = WidgetData(
        userName: "ゲスト",
        points: 0,
        lastUpdated: Date(),
        theme: .light,
        style: .standard,
        showPoints: true,
        showDate: true
    )
}

struct Provider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")
    
    func loadWidgetData() -> WidgetData {
        guard let data = userDefaults?.data(forKey: "widgetData"),
              let widgetData = try? JSONDecoder().decode(WidgetData.self, from: data) else {
            return WidgetData.defaultData
        }
        return widgetData
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetData: WidgetData.defaultData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = loadWidgetData()
        let entry = SimpleEntry(date: Date(), widgetData: data)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let widgetData = loadWidgetData()
        
        // 5分ごとに更新
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 5, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, widgetData: widgetData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData
}

struct gaudyoshinokoEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.widgetData.userName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(entry.widgetData.points) pt")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("更新: \(entry.widgetData.lastUpdated, style: .time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct gaudyoshinoko: Widget {
    let kind: String = "gaudyoshinoko"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            gaudyoshinokoEntryView(entry: entry)
        }
        .configurationDisplayName("ガウディウィジェット")
        .description("ガウディの情報をホーム画面で確認できます")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct gaudyoshinoko_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = WidgetData(
            userName: "テストユーザー",
            points: 1234,
            lastUpdated: Date(),
            theme: .light,
            style: .standard,
            showPoints: true,
            showDate: true
        )
        gaudyoshinokoEntryView(entry: SimpleEntry(date: Date(), widgetData: sampleData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
