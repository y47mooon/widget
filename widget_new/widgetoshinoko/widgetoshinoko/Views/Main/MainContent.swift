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

struct MainContentView: View {
    @Binding var selectedCategory: Int
    let categories: [String]
    let filterTags: [String]
    
    var body: some View {
        NavigationView {  // NavigationViewを追加
            ScrollView {
                LazyVStack(spacing: 20) {
                    CategoryScrollView(selectedCategory: $selectedCategory, 
                                    categories: categories)
                    
                    if selectedCategory == 0 {
                        mainContent
                    } else {
                        selectedCategoryContent
                    }
                }
            }
        }
        .onDisappear {
            ImageCache.shared.removeImage(for: "current_category")
        }
    }
    
    // メインコンテンツビュー
    private var mainContent: some View {
        LazyVStack(spacing: 20) {
            // フィルタータグセクション
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(filterTags, id: \.self) { tag in
                        FilterChipView(title: tag)
                    }
                }
                .padding(.horizontal)
            }
            
            // 人気のホーム画面セクション
            VStack {
                HStack {
                    Text("人気のホーム画面")
                        .font(.headline)
                    Spacer()
                    NavigationLink(destination: CategoryDetailView(title: "人気のホーム画面")) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 200, height: 400)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // 人気のウィジェットセクション
            popularWidgetsSection
            
            // 人気のロック画面セクション
            VStack {
                HStack {
                    Text("人気のロック画面")
                        .font(.headline)
                    Spacer()
                    NavigationLink(destination: CategoryDetailView(title: "人気のロック画面")) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // カテゴリー選択時のコンテンツビュー
    private var selectedCategoryContent: some View {
        LazyVStack(spacing: 20) {
            // 人気のコンテンツ
            VStack {
                HStack {
                    Text("人気の\(categories[selectedCategory])")
                        .font(.headline)
                    Spacer()
                    NavigationLink(destination: CategoryDetailView(title: "人気の\(categories[selectedCategory])")) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // 新着のコンテンツ
            VStack {
                HStack {
                    Text("新着の\(categories[selectedCategory])")
                        .font(.headline)
                    Spacer()
                    NavigationLink(destination: CategoryDetailView(title: "新着の\(categories[selectedCategory])")) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // おしゃれなコンテンツ
            VStack {
                HStack {
                    Text("おしゃれな\(categories[selectedCategory])")
                        .font(.headline)
                    Spacer()
                    NavigationLink(destination: CategoryDetailView(title: "おしゃれな\(categories[selectedCategory])")) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // 人気のウィジェットセクション
    private var popularWidgetsSection: some View {
        PopularSection(
            title: "人気のウィジェット",
            items: 3,
            destination: WidgetListView(viewModel: .preview)
        )
    }
}

struct CategoryDetailView: View {
    let title: String
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(0..<4) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: (UIScreen.main.bounds.width - 48) / 2,
                               height: UIScreen.main.bounds.height * 0.5)
                }
            }
            .padding(16)
        }
        .navigationTitle(title)
    }
}

#Preview {
    @State var selectedCategory = 0
    
    return MainContentView(
        selectedCategory: $selectedCategory,
        categories: AppConstants.categories,
        filterTags: AppConstants.topFilterTags
    )
}