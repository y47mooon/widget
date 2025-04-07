//
//  FavoritesView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//
import SwiftUI
import GaudiyWidgetShared

struct FavoritesView: View {
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @State private var selectedCategory: GaudiyContentType? = nil
    @State private var gridLayout = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View {
        VStack(spacing: 0) {
            // カテゴリセグメントコントロール
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    categoryButton(title: "favorites_all".localized, category: nil)
                    
                    ForEach(GaudiyContentType.allCases, id: \.self) { category in
                        categoryButton(title: category.displayName, category: category)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // お気に入りコンテンツのグリッド表示
            ScrollView {
                if hasContent {
                    LazyVGrid(columns: gridLayout, spacing: 16) {
                        ForEach(getFavoriteItems()) { item in
                            favoriteItemView(item: item)
                        }
                    }
                    .padding()
                } else {
                    // お気に入りが空の場合 - 中央表示に修正
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "heart")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        Text("favorites_empty".localized)
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("favorites_empty_message".localized)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 500)
                }
            }
        }
        .navigationTitle("favorites_title".localized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // グリッドレイアウトの切り替え
                    toggleGridLayout()
                }) {
                    Image(systemName: gridLayout.count == 1 ? "square.grid.2x2" : "rectangle.grid.1x2")
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    // グリッドレイアウトの切り替え
    private func toggleGridLayout() {
        withAnimation {
            if gridLayout.count == 1 {
                gridLayout = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
            } else {
                gridLayout = [GridItem(.adaptive(minimum: 160))]
            }
        }
    }
    
    // カテゴリボタン
    private func categoryButton(title: String, category: GaudiyContentType?) -> some View {
        Button(action: {
            withAnimation {
                selectedCategory = category
            }
        }) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    selectedCategory == category ? 
                        Color.blue.opacity(0.2) : 
                        Color.gray.opacity(0.1)
                )
                .foregroundColor(
                    selectedCategory == category ? 
                        Color.blue : 
                        Color.black
                )
                .cornerRadius(16)
        }
    }
    
    // お気に入りアイテムビュー
    private func favoriteItemView(item: FavoriteItemViewModel) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                // サムネイル画像
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: item.contentType.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(20)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                    case .failure:
                        Image(systemName: item.contentType.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(20)
                            .background(Color.gray.opacity(0.1))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 120)
                .cornerRadius(12)
                
                // タイトルとタイプ
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(item.contentType.displayName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
            }
            .padding(.bottom, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            
            // お気に入りボタン（スタイリッシュなデザイン）
            Button(action: {
                // お気に入り解除
                withAnimation {
                    favoriteManager.toggleFavorite(id: item.id, contentType: item.contentType)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.pink)
                }
            }
            .padding(8)
        }
    }
    
    // コンテンツがあるかどうか
    private var hasContent: Bool {
        return !favoriteManager.getAllFavorites().isEmpty
    }
    
    // お気に入りアイテムを取得
    private func getFavoriteItems() -> [FavoriteItemViewModel] {
        // 実際のお気に入りUUIDを取得
        let favoriteIds: [UUID]
        if let category = selectedCategory {
            favoriteIds = favoriteManager.getFavorites(contentType: category)
        } else {
            favoriteIds = favoriteManager.getAllFavorites()
        }
        
        // TODO: 実際のデータストアからお気に入りアイテムの詳細情報を取得
        // 現在はサンプルデータを返す
        var items: [FavoriteItemViewModel] = []
        
        for id in favoriteIds {
            // 実際には、IDに基づいてデータベースやキャッシュからアイテム情報を取得
            // 例: let item = dataStore.getItem(id: id)
            
            // とりあえずダミーデータ
            items.append(FavoriteItemViewModel(
                id: id,
                title: "お気に入りアイテム \(id.uuidString.prefix(4))",
                imageUrl: "",
                contentType: selectedCategory ?? [.widget, .wallpaper, .icon, .template].randomElement()!,
                createdAt: Date()
            ))
        }
        
        return items
    }
    
    // モックデータ (実装中のみ使用)
    private func getMockItems() -> [FavoriteItemViewModel] {
        // サンプルデータがない場合は実際のお気に入りを返す
        if !favoriteManager.getAllFavorites().isEmpty {
            return getFavoriteItems()
        }
        
        var items = [
            FavoriteItemViewModel(
                id: UUID(),
                title: "アナログ時計ウィジェット",
                imageUrl: "",
                contentType: .widget,
                createdAt: Date()
            ),
            FavoriteItemViewModel(
                id: UUID(),
                title: "カレンダーウィジェット",
                imageUrl: "",
                contentType: .widget,
                createdAt: Date()
            ),
            FavoriteItemViewModel(
                id: UUID(),
                title: "春の壁紙",
                imageUrl: "",
                contentType: .wallpaper,
                createdAt: Date()
            ),
            FavoriteItemViewModel(
                id: UUID(),
                title: "アイコンセット1",
                imageUrl: "",
                contentType: .icon,
                createdAt: Date()
            ),
            FavoriteItemViewModel(
                id: UUID(),
                title: "夏のテンプレート",
                imageUrl: "",
                contentType: .template,
                createdAt: Date()
            )
        ]
        
        // 選択されたカテゴリでフィルタリング
        if let category = selectedCategory {
            items = items.filter { $0.contentType == category }
        }
        
        return items
    }
}

// お気に入りアイテムのビューモデル
struct FavoriteItemViewModel: Identifiable {
    let id: UUID
    let title: String
    let imageUrl: String
    let contentType: GaudiyContentType
    let createdAt: Date
}

// プレビュー
#Preview {
    NavigationView {
    FavoritesView()
    }
}