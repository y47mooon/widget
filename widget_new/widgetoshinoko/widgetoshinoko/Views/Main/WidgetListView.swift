import SwiftUI

struct WidgetListView: View {
    @StateObject private var viewModel: WidgetListViewModel
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .popular
    @State private var selectedSize: WidgetSize = .small
    
    init(viewModel: WidgetListViewModel? = nil) {
        let vm = viewModel ?? WidgetListViewModel(repository: MockWidgetRepository())
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // 検索バー
            CustomSearchBar(searchText: $viewModel.searchText)
            
            // サイズ選択セグメント
            Picker("サイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.rawValue)
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // ウィジェット表示部分
            if viewModel.isLoading {
                ProgressView()
            } else {
                widgetGridBySize
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("人気のウィジェット")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
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
    
    // サイズに応じたグリッド表示
    private var widgetGridBySize: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                switch selectedSize {
                case .small:
                    smallWidgetGrid
                case .medium:
                    mediumWidgetGrid
                case .large:
                    largeWidgetGrid
                }
            }
            .padding()
        }
    }
    
    // Small サイズのグリッド
    private var smallWidgetGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 16
        ) {
            ForEach(viewModel.widgets) { widget in
                WidgetItemView(widget: widget, height: 150)
            }
        }
    }
    
    // Medium サイズのグリッド
    private var mediumWidgetGrid: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.widgets) { widget in
                WidgetItemView(widget: widget, height: 200)
            }
        }
    }
    
    // Large サイズのグリッド
    private var largeWidgetGrid: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.widgets) { widget in
                WidgetItemView(widget: widget, height: 300)
            }
        }
    }
}

#Preview {
    NavigationView {
        WidgetListView(viewModel: .preview)
    }
}
