import SwiftUI

/// ホーム画面の「全て」タブで表示するコンテンツビュー
struct HomeContentView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // テンプレートセクション
            templateSection
            
            // ウィジェットセクション
            widgetSection
            
            // ロック画面セクション
            lockScreenSection
            
            // 壁紙セクション
            wallpaperSection
            
            // 動く壁紙セクション
            movingWallpaperSection
            
            // 下部に余白を追加してスクロール時の見やすさを改善
            Spacer()
                .frame(height: 40)
        }
        .padding(.bottom, 16)
    }
    
    // テンプレートセクション
    private var templateSection: some View {
        GenericSectionView(
            title: TemplateCategory.popular.rawValue,
            items: viewModel.templateItems,
            destination: ContentListView(
                category: TemplateCategory.popular,
                contentType: .template
            ),
            itemBuilder: { item, index in
                AnyView(
                    ContentItemView(
                        item: item,
                        contentType: .template,
                        index: index
                    )
                )
            }
        )
    }
    
    // ウィジェットセクション
    private var widgetSection: some View {
        let dummyItems: [Any] = viewModel.widgetItems.isEmpty ? [0, 1, 2, 3, 4] : viewModel.widgetItems
        
        return GenericSectionView<Any, WidgetListView>(
            title: WidgetCategory.popular.rawValue,
            items: dummyItems,
            destination: WidgetListView(
                viewModel: WidgetListViewModel(
                    repository: MockWidgetRepository(),
                    category: .popular
                )
            ),
            itemBuilder: { item, index in
                AnyView(
                    WidgetItemView(
                        widget: item is Int ? 
                            createDummyWidget(index: index) : 
                            item as! WidgetItem
                    )
                )
            }
        )
    }
    
    // ロック画面セクション
    private var lockScreenSection: some View {
        GenericSectionView(
            title: LockScreenCategory.popular.rawValue,
            items: viewModel.lockScreenItems,
            destination: ContentListView(
                category: LockScreenCategory.popular,
                contentType: .lockScreen
            ),
            itemBuilder: { item, index in
                AnyView(
                    ContentItemView(
                        item: item,
                        contentType: .lockScreen,
                        index: index
                    )
                )
            }
        )
    }
    
    // 壁紙セクション
    private var wallpaperSection: some View {
        GenericSectionView(
            title: WallpaperCategory.popular.rawValue,
            items: viewModel.wallpaperItems,
            destination: ContentListView(
                category: WallpaperCategory.popular,
                contentType: .wallpaper
            ),
            itemBuilder: { item, index in
                AnyView(
                    ContentItemView(
                        item: item,
                        contentType: .wallpaper,
                        index: index
                    )
                )
            }
        )
    }
    
    // 動く壁紙セクション
    private var movingWallpaperSection: some View {
        GenericSectionView(
            title: MovingWallpaperCategory.popular.rawValue,
            items: viewModel.movingWallpaperItems,
            destination: ContentListView(
                category: MovingWallpaperCategory.popular,
                contentType: .movingWallpaper
            ),
            itemBuilder: { item, index in
                AnyView(
                    ContentItemView(
                        item: item,
                        contentType: .movingWallpaper,
                        index: index
                    )
                )
            }
        )
    }
    
    private func createDummyWidget(index: Int) -> WidgetItem {
        WidgetItem(
            id: UUID(),
            title: "ダミーウィジェット \(index + 1)",
            description: "ダミーの説明文です",
            imageUrl: "placeholder",
            category: WidgetCategory.popular.rawValue,
            popularity: 100,
            createdAt: Date()
        )
    }
}

// プレビュー
#Preview {
    HomeContentView(viewModel: MainContentViewModel())
}
