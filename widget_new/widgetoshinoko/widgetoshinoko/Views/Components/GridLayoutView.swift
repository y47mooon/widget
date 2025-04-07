import SwiftUI  // Viewプロトコルのために必要

struct GridLayoutView<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let isLargeStyle: Bool
    let content: (Item) -> Content
    
    init(
        items: [Item],
        isLargeStyle: Bool = false,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.isLargeStyle = isLargeStyle
        self.content = content
    }
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                isLargeStyle ? nil : GridItem(.flexible(), spacing: 16)
            ].compactMap { $0 },
            spacing: 16
        ) {
            ForEach(items) { item in
                content(item)
            }
        }
        .padding(.horizontal, 16)
    }
}
