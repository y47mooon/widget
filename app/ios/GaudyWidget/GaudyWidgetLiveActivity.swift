//
//  GaudyWidgetLiveActivity.swift
//  GaudyWidget
//
//  Created by ゆぅ on 2025/03/01.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GaudyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GaudyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GaudyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GaudyWidgetAttributes {
    fileprivate static var preview: GaudyWidgetAttributes {
        GaudyWidgetAttributes(name: "World")
    }
}

extension GaudyWidgetAttributes.ContentState {
    fileprivate static var smiley: GaudyWidgetAttributes.ContentState {
        GaudyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GaudyWidgetAttributes.ContentState {
         GaudyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GaudyWidgetAttributes.preview) {
   GaudyWidgetLiveActivity()
} contentStates: {
    GaudyWidgetAttributes.ContentState.smiley
    GaudyWidgetAttributes.ContentState.starEyes
}
