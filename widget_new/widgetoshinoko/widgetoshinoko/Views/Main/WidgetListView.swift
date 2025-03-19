import SwiftUI

struct WidgetListView: View {
    @StateObject private var viewModel: WidgetListViewModel
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .popular
    @State private var selectedSize: WidgetSize = .small
    @State private var searchText: String = ""
    let category: WidgetCategory
    
    init(viewModel: WidgetListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.category = viewModel.category
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 検索バー
            CustomSearchBar(searchText: $searchText)
                .padding()
            
            // サイズ選択
            Picker("ウィジェットサイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.rawValue)
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // ウィジェット一覧
            ScrollView {
                switch selectedSize {
                case .small:
                    smallWidgetGrid
                case .medium:
                    mediumWidgetList
                case .large:
                    largeWidgetList
                }
            }
        }
        .navigationTitle(category.rawValue)
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
    
    // Small サイズのグリッド（2列）
    private var smallWidgetGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(viewModel.widgets) { widget in
                WidgetSizeView(size: .small, title: widget.title)
            }
        }
        .padding()
    }
    
    // Medium サイズのリスト（1列）
    private var mediumWidgetList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.widgets) { widget in
                WidgetSizeView(size: .medium, title: widget.title)
            }
        }
        .padding()
    }
    
    // Large サイズのリスト（1列）
    private var largeWidgetList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.widgets) { widget in
                WidgetSizeView(size: .large, title: widget.title)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        WidgetListView(viewModel: .preview)
    }
}
