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
        GenericSectionView(
            title: "人気のウィジェット",
            items: (0..<10).map { $0 }, // インデックスのみの配列
            destination: WidgetListView(
                viewModel: WidgetListViewModel(
                    repository: MockWidgetRepository(),
                    category: .popular
                )
            ),
            itemBuilder: { index, _ in
                AnyView(
                    // 条件演算子を使用して決定
                    index % 2 == 0 ?
                    // 細長いウィジェット
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 140, height: 80)
                        .overlay(
                            Text("時計ウィジェット")
                                .font(.caption)
                                .foregroundColor(.gray)
                        )
                    :
                    // 正方形のアイコンサイズウィジェット
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("天気")
                                .font(.caption)
                                .foregroundColor(.gray)
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
}

// プレビュー
#Preview {
    HomeContentView(viewModel: MainContentViewModel())
}
