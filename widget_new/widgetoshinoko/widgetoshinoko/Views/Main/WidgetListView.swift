import Foundation
import SwiftUI
import GaudiyWidgetShared


struct WidgetListView: View {
    @ObservedObject var viewModel: WidgetListViewModel
    @State private var selectedSize: WidgetSize = .small
    @State private var searchText = ""
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .newest
    @StateObject private var presetViewModel = WidgetPresetViewModel()
    
    let itemBuilder: (WidgetSize) -> any View
    
    init(viewModel: WidgetListViewModel, itemBuilder: @escaping (WidgetSize) -> any View) {
        self.viewModel = viewModel
        self.itemBuilder = itemBuilder
    }
    
    // columnsをコンピューテッドプロパティとして定義
    private var columns: [GridItem] {
        switch selectedSize {
        case .small:
            return [GridItem(.adaptive(minimum: 100), spacing: 16)]
        case .medium:
            return [GridItem(.adaptive(minimum: 150), spacing: 16)]
        case .large:
            return [GridItem(.adaptive(minimum: 300), spacing: 16)]
        }
    }
    
    // itemWidthを取得する関数
    private func itemWidth(for size: WidgetSize) -> CGFloat {
        switch size {
        case .small: return 100
        case .medium: return 150
        case .large: return 300
        }
    }
    
    // itemHeightを取得する関数
    private func itemHeight(for size: WidgetSize) -> CGFloat {
        switch size {
        case .small: return 100
        case .medium: return 150
        case .large: return 300
        }
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
            
            // サイズに応じてレイアウトを切り替え
            if selectedSize == .small {
                gridLayout
            } else if selectedSize == .medium {
                listLayout
            } else {
                gridLayout
            }
        }
        .navigationTitle(viewModel.category.displayName)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(id: "sortButton", placement: .navigationBarTrailing) {
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
        .onAppear {
            // 初回表示時にプリセットを読み込む
            Task {
                // 全タイプのプリセットを読み込む
                for type in WidgetType.allCases {
                    await presetViewModel.loadPresets(type: type)
                }
            }
        }
        .onChange(of: selectedSize) { newSize in
            // サイズが変わったらプリセットをフィルタリング
            presetViewModel.filterBySize(newSize)
        }
    }
    
    // グリッドレイアウト（小サイズと大サイズ用）
    private var gridLayout: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                // プリセットを表示
                let presets = presetViewModel.getPresets(for: viewModel.category, size: selectedSize)
                
                if presets.isEmpty {
                    // プリセットがない場合はダミーデータを表示
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: itemWidth(for: selectedSize), 
                                   height: itemHeight(for: selectedSize))
                    }
                } else {
                    // プリセットを表示
                    ForEach(presets, id: \.id) { preset in
                        NavigationLink(
                            destination: WidgetPresetPreviewView(
                                preset: preset,
                                onComplete: {
                                    // 設定完了後の処理
                                }
                            )
                        ) {
                            WidgetPresetItemView(preset: preset)
                                .frame(width: itemWidth(for: selectedSize), 
                                       height: itemHeight(for: selectedSize))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
    
    // リストレイアウト（中サイズ用）
    private var listLayout: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // プリセットを表示
                let presets = presetViewModel.getPresets(for: viewModel.category, size: selectedSize)
                
                if presets.isEmpty {
                    // プリセットがない場合はダミーデータを表示
                    ForEach(0..<4) { _ in
                        createDummyListItem()
                    }
                } else {
                    // プリセットを表示
                    ForEach(presets, id: \.id) { preset in
                        NavigationLink(
                            destination: WidgetPresetPreviewView(
                                preset: preset,
                                onComplete: {
                                    // 設定完了後の処理
                                }
                            )
                        ) {
                            createListItem(
                                title: preset.title.isEmpty ? preset.description : preset.title,
                                description: preset.title.isEmpty ? "" : preset.description
                            ) {
                                AnyView(
                                    WidgetPresetItemView(preset: preset)
                                        .frame(width: 100, height: 100)
                                )
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
    
    // リスト表示用の共通アイテム生成関数
    private func createListItem(title: String, description: String, @ViewBuilder content: () -> AnyView) -> some View {
        HStack(spacing: 16) {
            // 左側：ウィジェットプレビュー
            content()
            
            // 右側：テキスト情報
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                if !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.Layout.cornerRadius)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }
    
    // ダミーリストアイテム
    private func createDummyListItem() -> some View {
        HStack(spacing: 16) {
            // 左側：ダミープレビュー
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 100)
            
            // 右側：ダミーテキスト
            VStack(alignment: .leading, spacing: 4) {
                Text("ウィジェットタイトル")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("ウィジェットの説明文がここに表示されます")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.Layout.cornerRadius)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }
}

#Preview {
    NavigationView {
        WidgetListView(viewModel: .previewViewModel, itemBuilder: { size in
            WidgetSizeView(size: size)
        })
    }
}
