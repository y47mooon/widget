import SwiftUI

// ウィジェットサイズの列挙型を追加
enum WidgetSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}

// ウィジェット専用の詳細ビューを作成
struct WidgetDetailView: View {
    let title: String
    @State private var selectedSize: WidgetSize = .small
    // 表示するアイテム数を制御するための状態変数を追加
    @State private var visibleItems: Int = 10
    
    var body: some View {
        VStack(spacing: 0) {
            // サイズ選択セグメントコントロール
            Picker("ウィジェットサイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.rawValue)
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // ウィジェット一覧を最適化
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 16
                ) {
                    ForEach(0..<visibleItems, id: \.self) { index in
                        WidgetSizeView(size: selectedSize)
                            .onAppear {
                                // 最後のアイテムが表示されたら、さらにアイテムを追加
                                if index == visibleItems - 1 && visibleItems < 20 {
                                    visibleItems += 5
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(title)
    }
}

// ウィジェットアイテムを別のビューとして分離
struct WidgetSizeView: View {
    let size: WidgetSize
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: frameHeight)
            .animation(.easeInOut, value: size)
    }
    
    private var frameHeight: CGFloat {
        switch size {
        case .small: return 150
        case .medium: return 200
        case .large: return 250
        }
    }
}

// 1. まずImageCacheの実装
final class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 50 // 50MB
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeImage(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}

struct MainContent: View {
    @State private var selectedSection = 0
    @StateObject private var templateViewModel = ContentListViewModel(
        repository: MockContentRepository(),
        category: TemplateCategory.popular
    )
    @StateObject private var wallpaperViewModel = ContentListViewModel(
        repository: MockContentRepository(),
        category: WallpaperCategory.popular
    )
    @StateObject private var lockScreenViewModel = ContentListViewModel(
        repository: MockContentRepository(),
        category: LockScreenCategory.popular
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // カテゴリー選択部分（既存のまま）
                    CategoryScrollView(
                        selectedCategory: $selectedSection,
                        categories: AppConstants.categories
                    )
                    
                    // フィルタータグ（全ての時のみ表示）
                    if selectedSection == 0 {  // "全て"が選択されている時のみ
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(AppConstants.topFilterTags, id: \.self) { tag in
                                    FilterChipView(title: tag)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // コンテンツ表示部分（既存のまま）
                    switch selectedSection {
                    case 0: // 全て
                        allContentView
                    case 1: // テンプレート
                        ContentCategorySection(
                            title: TemplateCategory.popular.rawValue,
                            items: templateViewModel.items,
                            category: .popular,
                            contentType: .template
                        )
                    case 2: // ウィジェット
                        WidgetCategoryListView()
                    // 他のケースも同様に実装
                    default:
                        Text(AppConstants.categories[selectedSection])
                    }
                }
            }
            .task {
                await loadInitialData()
            }
        }
    }
    
    private var allContentView: some View {
        VStack(spacing: 24) {
            // 人気のホーム画面セクション
            ContentCategorySection(
                title: TemplateCategory.popular.rawValue,
                items: templateViewModel.items,
                category: .popular,
                contentType: .template
            )
            
            // 人気のウィジェットセクション
            popularWidgetsSection
            
            // 人気のロック画面セクション
            ContentCategorySection(
                title: LockScreenCategory.popular.rawValue,
                items: lockScreenViewModel.items,
                category: LockScreenCategory.popular,
                contentType: .lockScreen
            )
            
            // おしゃれセクション
            ContentCategorySection(
                title: LockScreenCategory.stylish.rawValue,
                items: lockScreenViewModel.items,
                category: LockScreenCategory.stylish,
                contentType: .lockScreen
            )
            
            // シンプルセクション
            ContentCategorySection(
                title: LockScreenCategory.simple.rawValue,
                items: lockScreenViewModel.items,
                category: LockScreenCategory.simple,
                contentType: .lockScreen
            )
            
            // 星野アイセクション
            ContentCategorySection(
                title: LockScreenCategory.ai.rawValue,
                items: lockScreenViewModel.items,
                category: LockScreenCategory.ai,
                contentType: .lockScreen
            )
            
            // 星野ルビーセクション
            ContentCategorySection(
                title: LockScreenCategory.ruby.rawValue,
                items: lockScreenViewModel.items,
                category: LockScreenCategory.ruby,
                contentType: .lockScreen
            )
        }
    }
    
    private func loadInitialData() async {
        await templateViewModel.loadItems(limit: 5)
        await wallpaperViewModel.loadItems(limit: 5)
        await lockScreenViewModel.loadItems(limit: 5)
    }
    
    // 人気のウィジェットセクション
    private var popularWidgetsSection: some View {
        let viewModel = WidgetListViewModel(
            repository: MockWidgetRepository(),
            category: WidgetCategory.popular
        )
        
        return WidgetCategorySection(
            title: "人気のウィジェット",
            items: 3,
            destination: WidgetListView(viewModel: viewModel)
        )
    }
}

struct CategoryDetailView: View {
    let title: String
    let spacing: CGFloat = 16
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(0..<10) { index in
                    // 固定の縦幅を使用
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: UIScreen.main.bounds.height * 0.35) // 画面高さの35%
                        .overlay(
                            // 実際の画像がある場合はここに表示
                            Image("placeholder")
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        )
                }
            }
            .padding()
        }
        .navigationTitle("title")
    }
}

// プレビュー用
#Preview {
    MainContent()
}