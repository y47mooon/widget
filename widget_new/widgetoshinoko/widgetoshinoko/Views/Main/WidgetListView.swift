import SwiftUI

struct WidgetListView: View {
    @StateObject private var viewModel: WidgetListViewModel
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .popular
    @State private var selectedSize: WidgetSize = .small
    @State private var searchText: String = ""
    
    var filteredWidgets: [WidgetItem] {
        let widgets = viewModel.widgetItems
        if searchText.isEmpty {
            return widgets
        }
        return widgets.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var columns: [GridItem] {
        switch selectedSize {
        case .small:
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]
        case .medium, .large:
            return [GridItem(.flexible())]
        }
    }
    
    init(viewModel: WidgetListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                        // データがない場合はダミーのウィジェットを表示
                        ForEach(0..<10) { _ in
                            WidgetSizeView(size: selectedSize)
                        }
                    } else {
                        ForEach(viewModel.filteredWidgets, id: \.id) { widget in
                            WidgetSizeView(size: selectedSize)
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
        WidgetListView(viewModel: .previewViewModel)
    }
}
