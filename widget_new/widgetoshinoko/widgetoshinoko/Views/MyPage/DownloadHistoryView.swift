import SwiftUI
import GaudiyWidgetShared

struct DownloadHistoryView: View {
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @State private var selectedCategory: GaudiyContentType? = nil
    
    // 日付フォーマッター
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            // カテゴリセグメントコントロール
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    categoryButton(title: "全て", category: nil)
                    
                    ForEach(GaudiyContentType.allCases, id: \.self) { category in
                        categoryButton(title: category.displayName, category: category)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // 履歴リスト
            ScrollView {
                LazyVStack(spacing: 16) {
                    if filteredHistory.isEmpty {
                        if favoriteManager.downloadHistory.isEmpty {
                            // ダウンロード履歴が全くない場合
                            emptyStateView
                        } else {
                            // 選択カテゴリの履歴がない場合
                            Text("この種類のダウンロード履歴はまだありません")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else {
                        ForEach(filteredHistory) { item in
                            downloadHistoryRow(item: item)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("mypage_download_history".localized)
    }
    
    // 空の場合の表示
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("ダウンロード履歴がありません")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("ウィジェットや壁紙を保存すると\nここに履歴が表示されます")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
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
    
    // ダウンロード履歴行
    private func downloadHistoryRow(item: DownloadHistoryItem) -> some View {
        NavigationLink(destination: getDetailView(for: item)) {
            HStack(spacing: 12) {
                // コンテンツ画像
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: item.contentType.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: item.contentType.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 56, height: 56)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Text(item.contentType.displayName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(dateFormatter.string(from: item.downloadDate))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // コンテンツタイプに対応する詳細ビューを取得
    private func getDetailView(for item: DownloadHistoryItem) -> some View {
        switch item.contentType {
        case .widget:
            return AnyView(Text("ウィジェット詳細").navigationTitle(item.title))
        case .wallpaper:
            return AnyView(Text("壁紙詳細").navigationTitle(item.title))
        case .lockScreen:
            return AnyView(Text("ロック画面詳細").navigationTitle(item.title))
        case .icon:
            return AnyView(Text("アイコン詳細").navigationTitle(item.title))
        case .template:
            return AnyView(Text("テンプレート詳細").navigationTitle(item.title))
        case .movingWallpaper:
            return AnyView(Text("動く壁紙詳細").navigationTitle(item.title))
        }
    }
    
    // フィルタリングされた履歴を取得
    private var filteredHistory: [DownloadHistoryItem] {
        guard let category = selectedCategory else {
            return favoriteManager.getDownloadHistory()
        }
        return favoriteManager.getDownloadHistory(contentType: category)
    }
}

// プレビュー
#Preview {
    NavigationView {
        DownloadHistoryView()
    }
}
