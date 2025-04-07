import SwiftUI
import GaudiyWidgetShared

struct CalendarPresetItemView: View {
    let widget: WidgetItem
    @State private var showPreview = false
    
    var body: some View {
        Button(action: {
            showPreview = true
        }) {
            HStack {
                // 左側にカレンダーアイコン
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    
                    VStack {
                        Text(currentMonthDay())
                            .font(.system(size: 30, weight: .bold))
                        
                        Text(currentWeekday())
                            .font(.caption)
                    }
                }
                
                // テキスト情報
                VStack(alignment: .leading, spacing: 4) {
                    Text(widget.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("今日の日付: \(formattedDate())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                // 右端に矢印アイコン
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showPreview) {
            // ウィジェットプレビューを標準化されたビューに変更
            let preset = convertToWidgetPreset(widget)
            NavigationView {
                WidgetPresetPreviewView(preset: preset)
            }
        }
    }
    
    // WidgetItemをWidgetPresetに変換する関数
    private func convertToWidgetPreset(_ widget: WidgetItem) -> WidgetPreset {
        return WidgetPreset(
            id: widget.id,
            title: widget.title,
            description: widget.description ?? "カレンダーウィジェット",
            type: .calendar,
            size: .small,
            style: "default",
            imageUrl: widget.imageUrl,
            backgroundColor: nil,
            requiresPurchase: widget.requiresPurchase,
            isPurchased: widget.isPurchased,
            configuration: [:]
        )
    }
    
    // 今日の日付（例：15日）
    private func currentMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }
    
    // 今日の曜日（例：月）
    private func currentWeekday() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "E"
        return formatter.string(from: Date())
    }
    
    // フォーマットされた日付
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E)"
        return formatter.string(from: Date())
    }
}

// 古いCalendarPreviewViewは削除または非推奨にして、代わりにWidgetPresetPreviewViewを使用
// この方法で型の安全性を保ちながら参照を残しておく
typealias CalendarPreviewView = EmptyView
