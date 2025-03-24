import SwiftUI

struct WidgetCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(WidgetCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.displayName,
                        seeMoreText: "button_see_more".localized,
                        items: getDummyWidgets(for: category),
                        destination: WidgetListView(
                            viewModel: WidgetListViewModel(
                                repository: MockWidgetRepository(),
                                category: category
                            )
                        ),
                        itemBuilder: { item, index in
                            AnyView(
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: calculateWidgetWidth(), height: 100)
                                    .cornerRadius(12)
                                    .overlay(
                                        Text((item as! WidgetItem).title)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                            .padding(.horizontal, 8)
                                    )
                            )
                        }
                    )
                }
            }
            .padding(.vertical)
        }
    }
    
    // ウィジェットの横幅を計算するヘルパーメソッド
    private func calculateWidgetWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2  // 画面の左右パディング
        let spacing: CGFloat = 8       // アイテム間の間隔
        let itemCount: CGFloat = 5     // 横に表示するアイテム数
        let totalSpacing = spacing * (itemCount - 1)
        
        return (screenWidth - padding - totalSpacing) / itemCount
    }
    
    // ダミーデータを生成する関数
    private func getDummyWidgets(for category: WidgetCategory) -> [WidgetItem] {
        return (0..<5).map { index in
            WidgetItem(
                id: UUID(),
                title: "\(category.displayName) \(index + 1)",
                description: "ダミーの説明文です",
                imageUrl: "placeholder",
                category: category.rawValue,
                popularity: 100,
                createdAt: Date()
            )
        }
    }
}

#Preview {
    WidgetCategoryListView(viewModel: MainContentViewModel())
}
