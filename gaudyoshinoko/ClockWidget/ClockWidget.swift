//
//  ClockWidget.swift
//  gaudyoshinokoExtension
//
//  Created by ゆぅ on 2025/03/25.
//

import WidgetKit
import SwiftUI

struct ClockWidget: Widget {
    let kind = "ClockWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockWidgetProvider()) { entry in
            VStack {
                Text(entry.date, style: .time)
                    .font(.system(size: 36, weight: .bold))
                Text(entry.date, style: .date)
                    .font(.caption)
            }
            .padding()
        }
        .configurationDisplayName("時計ウィジェット")
        .description("シンプルな時計ウィジェット")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
