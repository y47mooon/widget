//
//  CalendarWidgetView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/04/04.
//

import Foundation
import SwiftUI
import GaudiyWidgetShared

struct CalendarWidgetView: View {
    let size: WidgetSize
    let configuration: [String: Any]
    
    var body: some View {
        VStack {
            Text(Date(), style: .date)
                .font(.system(size: size == .small ? 14 : 18))
                .fontWeight(.bold)
            
            if size != .small {
                // カレンダーグリッド（中・大サイズ用）
                VStack(spacing: 4) {
                    // 曜日の表示
                    HStack {
                        ForEach(["日", "月", "火", "水", "木", "金", "土"], id: \.self) { day in
                            Text(day)
                                .font(.caption2)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(day == "日" ? .red : .primary)
                        }
                    }
                    
                    // 日付の表示（例として）
                    ForEach(0..<4) { row in
                        HStack {
                            ForEach(1..<8) { col in
                                let day = row * 7 + col
                                if day <= 28 {
                                    Text("\(day)")
                                        .font(.caption)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(col == 1 ? .red : .primary)
                                        .background(day == 15 ? Color.blue.opacity(0.3) : Color.clear)
                                        .clipShape(Circle())
                                } else {
                                    Text("")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
    }
}

struct CalendarWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarWidgetView(size: .small, configuration: [:])
                .previewLayout(.sizeThatFits)
                .padding()
            
            CalendarWidgetView(size: .medium, configuration: [:])
                .previewLayout(.sizeThatFits)
                .padding()
            
            CalendarWidgetView(size: .large, configuration: [:])
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
