//
//  gaudyoshinokoLiveActivity.swift
//  gaudyoshinoko
//
//  Created by ゆぅ on 2025/03/02.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct gaudyoshinokoAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct gaudyoshinokoLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: gaudyoshinokoAttributes.self) { context in
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

extension gaudyoshinokoAttributes {
    fileprivate static var preview: gaudyoshinokoAttributes {
        gaudyoshinokoAttributes(name: "World")
    }
}

extension gaudyoshinokoAttributes.ContentState {
    fileprivate static var smiley: gaudyoshinokoAttributes.ContentState {
        gaudyoshinokoAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: gaudyoshinokoAttributes.ContentState {
         gaudyoshinokoAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: gaudyoshinokoAttributes.preview) {
   gaudyoshinokoLiveActivity()
} contentStates: {
    gaudyoshinokoAttributes.ContentState.smiley
    gaudyoshinokoAttributes.ContentState.starEyes
}
