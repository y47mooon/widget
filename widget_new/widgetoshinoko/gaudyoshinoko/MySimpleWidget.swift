//
//  MySimpleWidget.swift
//  gaudyoshinokoExtension
//
//  Created by ゆぅ on 2025/04/04.
//

import WidgetKit
import SwiftUI

// ウィジェットに表示するデータ
struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
}

// データプロバイダー
struct Provider: TimelineProvider {
    // App Group経由で直接UserDefaultsを使用
    private let userDefaults = UserDefaults(suiteName: "group.com.gaudiy.widgetoshinoko")
    private let messageKey = "widget_message"
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "プレースホルダー")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let message = userDefaults?.string(forKey: messageKey) ?? "スナップショット"
        let entry = SimpleEntry(date: Date(), message: message)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // UserDefaultsからメッセージを取得
        let message = userDefaults?.string(forKey: messageKey) ?? "こんにちは"
        
        let entry = SimpleEntry(date: Date(), message: message)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// ウィジェットビュー
struct MySimpleWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text(entry.date, style: .time)
                .font(.largeTitle)
            Text(entry.message)
                .font(.body)
        }
        .padding()
    }
}

// ウィジェット定義
struct MySimpleWidget: Widget {
    let kind: String = "MySimpleWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MySimpleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("マイウィジェット")
        .description("アプリからメッセージを設定できます")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
