import SwiftUI

struct IconListView: View {
    let category: IconCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<5) { index in
                    IconSetView(iconSet: createDummyIconSet(category: category, index: index))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .navigationTitle(category.rawValue)
    }
    
    private func createDummyIconSet(category: IconCategory, index: Int) -> IconSet {
        IconSet(
            id: UUID(),
            title: "\(category.rawValue) セット \(index + 1)",
            icons: (0..<4).map { _ in IconSet.Icon(id: UUID(), imageUrl: "placeholder", targetAppBundleId: nil) },
            category: category,
            popularity: 100,
            createdAt: Date()
        )
    }
}

#Preview {
    NavigationView {
        IconListView(category: .popular)
    }
}
