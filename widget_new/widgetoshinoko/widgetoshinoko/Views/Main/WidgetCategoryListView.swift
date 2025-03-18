import SwiftUI

struct WidgetCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(WidgetCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getWidgetItems(for: category), // モックデータの代わりにviewModelから取得
                        destination: WidgetListView(
                            viewModel: WidgetListViewModel(
                                repository: MockWidgetRepository(),
                                category: category
                            )
                        ),
                        itemBuilder: { item, _ in
                            AnyView(
                                WidgetItemView(widget: item, height: 80)
                            )
                        }
                    )
                }
            }
            .padding(.vertical)
        }
    }
}

// プレビュー用
#Preview {
    WidgetCategoryListView(viewModel: MainContentViewModel())
}
