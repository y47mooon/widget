import SwiftUI

struct WidgetCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(WidgetCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getWidgetItems(for: category),
                        destination: WidgetListView(
                            viewModel: WidgetListViewModel(
                                repository: MockWidgetRepository(),
                                category: category
                            )
                        ),
                        itemBuilder: { item, index in
                            AnyView(
                                WidgetItemView(widget: item)
                            )
                        }
                    )
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    WidgetCategoryListView(viewModel: MainContentViewModel())
}
