import SwiftUI

struct WidgetCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(WidgetCategory.allCases, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(category.rawValue)
                                .font(.headline)
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            NavigationLink(
                                destination: WidgetListView(
                                    viewModel: WidgetListViewModel(
                                        repository: MockWidgetRepository(),
                                        category: category
                                    )
                                )
                            ) {
                                Text("もっと見る")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                            }
                        }
                        
                        // ウィジェットを横スクロールで表示
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                // すべてのカテゴリで統一的にダミーデータを表示
                                ForEach(0..<5, id: \.self) { index in
                                    WidgetItemView(widget: createDummyWidget(category: category, index: index))
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.vertical)
        }
    }
    
    // カテゴリごとのダミーウィジェットを作成する補助関数
    private func createDummyWidget(category: WidgetCategory, index: Int) -> WidgetItem {
        WidgetItem(
            id: UUID(),
            title: "\(category.rawValue) \(index + 1)",
            description: "ダミーの説明文です",
            imageUrl: "placeholder",
            category: category.rawValue,
            popularity: 100,
            createdAt: Date()
        )
    }
}

#Preview {
    WidgetCategoryListView(viewModel: MainContentViewModel())
}
