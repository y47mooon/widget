import SwiftUI

struct IconCategoryListView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(IconCategory.allCases, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(category.rawValue)
                                .font(.headline)
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            NavigationLink(destination: IconListView(category: category)) {
                                Text("もっと見る")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<5) { index in
                                    IconSetView(
                                        iconSet: createDummyIconSet(category: category, index: index),
                                        isLargeStyle: category == .new // 新着カテゴリーの場合は大きいアイコン表示
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("アイコン")
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

// プレビュー用
#Preview {
    NavigationView {
        IconCategoryListView()
    }
}
