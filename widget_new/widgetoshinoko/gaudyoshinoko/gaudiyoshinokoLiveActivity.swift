//
//  gaudiyoshinokoLiveActivity.swift
//  gaudiyoshinoko
//
//  Created by ゆぅ on 2025/03/02.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct gaudiyoshinokoAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct gaudiyoshinokoLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: gaudiyoshinokoAttributes.self) { context in
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

extension gaudiyoshinokoAttributes {
    fileprivate static var preview: gaudiyoshinokoAttributes {
        gaudiyoshinokoAttributes(name: "World")
    }
}

extension gaudiyoshinokoAttributes.ContentState {
    fileprivate static var smiley: gaudiyoshinokoAttributes.ContentState {
        gaudiyoshinokoAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: gaudiyoshinokoAttributes.ContentState {
         gaudiyoshinokoAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: gaudiyoshinokoAttributes.preview) {
   gaudiyoshinokoLiveActivity()
} contentStates: {
    gaudiyoshinokoAttributes.ContentState.smiley
    gaudiyoshinokoAttributes.ContentState.starEyes
}
