import SwiftUI

struct WidgetItemView: View {
    let widget: WidgetItem
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: height)
            .cornerRadius(12)
    }
}

#Preview {
    WidgetItemView(widget: MockData.widgets[0], height: 200)
}
