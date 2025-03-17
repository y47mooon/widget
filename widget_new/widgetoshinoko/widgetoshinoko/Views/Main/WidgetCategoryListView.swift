import SwiftUI

struct WidgetCategoryListView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(WidgetCategory.allCases, id: \.self) { category in
                    WidgetCategorySection(
                        title: category.rawValue,
                        items: 3,
                        destination: WidgetListView(
                            viewModel: WidgetListViewModel(
                                repository: MockWidgetRepository(),
                                category: category
                            )
                        )
                    )
                }
            }
            .padding(.vertical)
        }
    }
}

// プレビュー用
#Preview {
    WidgetCategoryListView()
}
