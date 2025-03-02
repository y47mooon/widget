//
//  gaudyoshinoko.swift
//  gaudyoshinoko
//
//  Created by ゆぅ on 2025/02/26.
//

import WidgetKit
import SwiftUI

// CustomWidgetConfigの定義
struct CustomWidgetConfig: Codable, Identifiable {
    var id = UUID()
    var name: String
    var backgroundColor: String // HEX形式の色コード
    var textColor: String // HEX形式の色コード
    var imageName: String?
    var text: String
    var fontSize: Double
    var showBorder: Bool
    var borderColor: String
    var cornerRadius: Double
    
    static let defaultConfig = CustomWidgetConfig(
        name: "マイウィジェット",
        backgroundColor: "#FFFFFF",
        textColor: "#000000",
        imageName: nil,
        text: "カスタムテキスト",
        fontSize: 16.0,
        showBorder: true,
        borderColor: "#CCCCCC",
        cornerRadius: 12.0
    )
}

// Color拡張を追加
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

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
    var customWidgets: [CustomWidgetConfig]
    
    static let defaultData = WidgetData(
        userName: "ゲスト",
        points: 0,
        lastUpdated: Date(),
        theme: .light,
        style: .standard,
        showPoints: true,
        showDate: true,
        customWidgets: []
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
        switch entry.widgetData.style {
        case .standard:
            standardWidget
        case .minimal:
            minimalWidget
        case .fancy:
            fancyWidget
        case .calendar:
            calendarWidget
        }
        
        // カスタムウィジェットを表示する場合
        if !entry.widgetData.customWidgets.isEmpty,
           let firstCustomWidget = entry.widgetData.customWidgets.first {
            customWidgetView(config: firstCustomWidget)
        }
    }
    
    // スタンダードスタイル
    var standardWidget: some View {
        ZStack {
            entry.widgetData.theme.backgroundColor
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.widgetData.userName)
                        .font(.headline)
                        .foregroundColor(entry.widgetData.theme.textColor)
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                
                if entry.widgetData.showPoints {
                    Text("\(entry.widgetData.points) pt")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                if entry.widgetData.showDate {
                    Text("更新: \(entry.widgetData.lastUpdated, style: .time)")
                        .font(.caption)
                        .foregroundColor(entry.widgetData.theme.textColor.opacity(0.7))
                }
            }
            .padding()
        }
    }
    
    // ミニマルスタイル
    var minimalWidget: some View {
        ZStack {
            entry.widgetData.theme.backgroundColor
            
            VStack(spacing: 4) {
                Text(entry.widgetData.userName)
                    .font(.caption)
                    .foregroundColor(entry.widgetData.theme.textColor)
                
                if entry.widgetData.showPoints {
                    Text("\(entry.widgetData.points)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(entry.widgetData.theme.textColor)
                }
                
                if entry.widgetData.showDate {
                    Text(entry.widgetData.lastUpdated, style: .time)
                        .font(.caption2)
                        .foregroundColor(entry.widgetData.theme.textColor.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // ファンシースタイル
    var fancyWidget: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    entry.widgetData.theme.backgroundColor,
                    entry.widgetData.theme == .light ? Color.blue.opacity(0.3) : Color.purple.opacity(0.5)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                    
                    Text(entry.widgetData.userName)
                        .font(.headline)
                        .foregroundColor(entry.widgetData.theme.textColor)
                    
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                }
                
                if entry.widgetData.showPoints {
                    Text("\(entry.widgetData.points)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(entry.widgetData.theme.textColor)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
                    
                    Text("ポイント")
                        .font(.caption)
                        .foregroundColor(entry.widgetData.theme.textColor.opacity(0.8))
                }
                
                if entry.widgetData.showDate {
                    Text(entry.widgetData.lastUpdated, style: .date)
                        .font(.caption2)
                        .foregroundColor(entry.widgetData.theme.textColor.opacity(0.7))
                }
            }
            .padding()
        }
    }
    
    // カレンダースタイル
    var calendarWidget: some View {
        ZStack {
            entry.widgetData.theme.backgroundColor
            
            VStack(spacing: 0) {
                // カレンダーヘッダー
                HStack {
                    Text(monthString(from: entry.date))
                        .font(.caption)
                        .foregroundColor(entry.widgetData.theme.textColor)
                    
                    Spacer()
                    
                    Text(entry.widgetData.userName)
                        .font(.caption)
                        .foregroundColor(entry.widgetData.theme.textColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.2))
                
                // 日付
                Text("\(dayNumber(from: entry.date))")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(entry.widgetData.theme.textColor)
                    .padding(.vertical, 8)
                
                // ポイント
                if entry.widgetData.showPoints {
                    HStack {
                        Text("ポイント:")
                            .font(.caption)
                            .foregroundColor(entry.widgetData.theme.textColor.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\(entry.widgetData.points)")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.1))
                }
            }
        }
    }
    
    // 日付フォーマット用ヘルパー関数
    func monthString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: date)
    }
    
    func dayNumber(from date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    // カスタムウィジェット表示
    func customWidgetView(config: CustomWidgetConfig) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .fill(Color(hex: config.backgroundColor) ?? .white)
                .overlay(
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .stroke(config.showBorder ? Color(hex: config.borderColor) ?? .gray : Color.clear, lineWidth: 2)
                )
            
            VStack {
                if let imageName = config.imageName, let uiImage = loadImageFromDisk(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                }
                
                Text(config.text)
                    .font(.system(size: config.fontSize))
                    .foregroundColor(Color(hex: config.textColor) ?? .black)
                    .padding(.top, 4)
            }
            .padding()
        }
    }
    
    private func loadImageFromDisk(named: String) -> UIImage? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentDirectory.appendingPathComponent("\(named).jpg")
        return UIImage(contentsOfFile: imageURL.path)
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
            showDate: true,
            customWidgets: []
        )
        gaudyoshinokoEntryView(entry: SimpleEntry(date: Date(), widgetData: sampleData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
