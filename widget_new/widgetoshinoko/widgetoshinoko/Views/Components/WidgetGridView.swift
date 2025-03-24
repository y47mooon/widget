import SwiftUI

struct WidgetGridView: View {
    let widgets: [WidgetItem]
    let selectedSize: WidgetSize
    
    var body: some View {
        LazyVGrid(
            columns: LayoutCalculator.gridColumns(for: selectedSize), 
            spacing: DesignConstants.Layout.standardSpacing
        ) {
            ForEach(widgets, id: \.id) { widget in
                WidgetSizeView(size: selectedSize, title: widget.title)
            }
        }
        .padding()
    }
}

#Preview {
    WidgetGridView(
        widgets: [
            WidgetItem.preview,
            WidgetItem.preview,
            WidgetItem.preview,
            WidgetItem.preview
        ],
        selectedSize: .small
    )
}
