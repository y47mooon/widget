import SwiftUI

struct WidgetListView: View {
    @ObservedObject var viewModel: WidgetListViewModel
    @State private var selectedSize: WidgetSize = .small
    @State private var searchText = ""
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .newest
    
    let itemBuilder: (WidgetSize) -> any View
    
    init(viewModel: WidgetListViewModel, itemBuilder: @escaping (WidgetSize) -> any View) {
        self.viewModel = viewModel
        self.itemBuilder = itemBuilder
    }
    
    private var columns: [GridItem] {
        LayoutCalculator.gridColumns(for: selectedSize)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 検索バー
            CustomSearchBar(searchText: $searchText)
                .padding()
            
            // サイズ選択
            Picker("widget_size".localized, selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.displayName)
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // ウィジェット一覧
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    if viewModel.filteredWidgets.isEmpty {
                        ForEach(0..<10) { _ in
                            AnyView(itemBuilder(selectedSize))
                        }
                    } else {
                        ForEach(viewModel.filteredWidgets, id: \.id) { widget in
                            AnyView(itemBuilder(selectedSize))
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.category.displayName)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingSortOptions = true }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .popover(isPresented: $showingSortOptions) {
            SortOrderSelectionView(
                selectedOrder: $sortOrder,
                isPresented: $showingSortOptions
            )
            .onChange(of: sortOrder) { newOrder in
                viewModel.applySortOrder(newOrder)
            }
        }
        .task {
            await viewModel.loadWidgets()
        }
    }
}

#Preview {
    NavigationView {
        WidgetListView(viewModel: .previewViewModel, itemBuilder: { size in
            WidgetSizeView(size: size)
        })
    }
}
