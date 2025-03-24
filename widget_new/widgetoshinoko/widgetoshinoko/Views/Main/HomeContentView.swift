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
            title: "template_popular".localized,
            seeMoreText: "button_see_more".localized,
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
        GenericSectionView(
            title: "section_popular_widgets".localized,
            seeMoreText: "button_see_more".localized,
            items: viewModel.widgetItems.isEmpty ? getDummyWidgets() : viewModel.widgetItems,
            destination: WidgetListView(
                viewModel: WidgetListViewModel(
                    repository: MockWidgetRepository(),
                    category: .popular
                )
            ),
            itemBuilder: { item, index in
                AnyView(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: calculateWidgetWidth(), height: 100)
                        .cornerRadius(12)
                )
            }
        )
    }
    
    // ウィジェットの横幅を計算するヘルパーメソッド
    private func calculateWidgetWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2  // 画面の左右パディング
        let spacing: CGFloat = 16      // アイテム間の間隔
        return (screenWidth - padding - spacing) / 2  // 2列表示
    }
    
    // ロック画面セクション
    private var lockScreenSection: some View {
        GenericSectionView(
            title: "lockscreen_popular".localized,
            seeMoreText: "button_see_more".localized,
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
            seeMoreText: "button_see_more".localized,
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
            seeMoreText: "button_see_more".localized,
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
    
    // ダミーデータを生成する関数
    private func getDummyWidgets() -> [WidgetItem] {
        return (0..<5).map { index in
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
}

// プレビュー
#Preview {
    HomeContentView(viewModel: MainContentViewModel())
}
