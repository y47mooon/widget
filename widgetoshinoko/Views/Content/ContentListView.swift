import SwiftUI

struct ContentListView<Category: CategoryType>: View {
    let category: Category
    let contentType: ContentType
    @StateObject private var viewModel: ContentListViewModel<Category>
    
    init(category: Category, contentType: ContentType) {
        self.category = category
        self.contentType = contentType
        _viewModel = StateObject(wrappedValue: ContentListViewModel(
            repository: MockContentRepository(),
            category: category
        ))
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                    ContentItemView(
                        item: item,
                        contentType: contentType,
                        index: index,
                        isInList: true
                    )
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .task {
            await viewModel.loadItems(limit: 10)
        }
    }
}