import SwiftUI
import GaudiyWidgetShared

struct ClockWidgetOverlay: View {
    let configuration: ClockConfiguration?
    
    var body: some View {
        if let config = configuration {
            ClockWidgetView(size: .small, configuration: config)
        } else {
            EmptyView()
        }
    }
}
