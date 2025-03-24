import SwiftUI

// メインカテゴリーの列挙型
enum MainCategory: Int, CaseIterable {
    case all = 0
    case template = 1
    case widget = 2
    case icon = 3
    case wallpaper = 4
    case lockScreen = 5
    case movingWallpaper = 6
    
    var title: String {
        switch self {
        case .all: return "category_all".localized
        case .template: return "category_template".localized
        case .widget: return "category_widget".localized
        case .icon: return "category_icon".localized
        case .wallpaper: return "category_wallpaper".localized
        case .lockScreen: return "category_lockScreen".localized
        case .movingWallpaper: return "category_movingWallpaper".localized
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

// MainContentの残りの実装
struct MainContent: View {
    @State private var selectedSection: Int = 0
    @State private var selectedTag: String = AppConstants.topFilterTags.first ?? ""
    @StateObject private var viewModel = MainContentViewModel()
    
    var body: some View {
        NavigationView {
            // ScrollViewを追加してスクロール可能に
            ScrollView {
                VStack(spacing: 0) {
                    // 既存のタブメニュー (下線スタイルに修正)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(MainCategory.allCases, id: \.rawValue) { category in
                                VStack(spacing: 4) {
                                    Text(category.title)
                                        .font(.system(size: 14, weight: selectedSection == category.rawValue ? .medium : .regular))
                                        .foregroundColor(selectedSection == category.rawValue ? .pink : .black)
                                    
                                    // 選択中のタブには下線を表示
                                    Rectangle()
                                        .fill(selectedSection == category.rawValue ? Color.pink : Color.clear)
                                        .frame(height: 2)
                                        .frame(width: 24)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectedSection = category.rawValue
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                
                // 全てタブの場合のみフィルタータグを表示
                if selectedSection == MainCategory.all.rawValue {
                    FilterTagsScrollView(
                        selectedTag: $selectedTag,
                        tags: AppConstants.topFilterTags
                    )
                }
                
                // 選択されたカテゴリーに応じたコンテンツを表示
                contentForSelectedCategory
                    .padding(.top, 8)
            }
            .navigationTitle("oshinoko")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("oshinoko")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, -8) // タイトルを少し上に移動
                }
            }
        }
        .task {
            await viewModel.loadAllData()
        }
    }
    
    private var contentForSelectedCategory: some View {
        Group {
            if let category = MainCategory(rawValue: selectedSection) {
                switch category {
                case .all:
                    HomeContentView(viewModel: viewModel)
                case .template:
                    TemplateContentView(viewModel: viewModel)
                case .widget:
                    WidgetCategoryListView(viewModel: viewModel)
                case .icon:
                    IconCategoryListView(viewModel: viewModel)
                case .wallpaper:
                    WallpaperContentView(viewModel: viewModel)
                case .lockScreen:
                    LockScreenContentView(viewModel: viewModel)
                case .movingWallpaper:
                    MovingWallpaperContentView(viewModel: viewModel)
                }
            } else {
                Text("カテゴリーが選択されていません")
                        .foregroundColor(.gray)
            }
        }
    }
}

// カテゴリーボタン
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .pink : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.pink : Color.gray.opacity(0.3), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isSelected ? Color.pink.opacity(0.1) : Color.white)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// プレビュー
#Preview {
    MainContent()
}