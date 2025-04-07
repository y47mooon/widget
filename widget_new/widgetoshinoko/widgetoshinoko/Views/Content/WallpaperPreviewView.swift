import SwiftUI
import GaudiyWidgetShared

struct WallpaperPreviewView: View {
    let imageUrl: String
    let title: String
    let type: WallpaperType
    let contentId: UUID
    
    @StateObject private var downloadManager = ContentDownloadManager.shared
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @State private var showingAlert = false
    @Environment(\.dismiss) private var dismiss
    
    enum WallpaperType {
        case wallpaper, lockScreen
        
        var contentType: GaudiyContentType {
            switch self {
            case .wallpaper: return .wallpaper
            case .lockScreen: return .lockScreen
            }
        }
    }
    
    // 初期化時にお気に入り状態を設定
    @State private var isLiked: Bool
    
    init(imageUrl: String, title: String, type: WallpaperType, contentId: UUID) {
        self.imageUrl = imageUrl
        self.title = title
        self.type = type
        self.contentId = contentId
        
        // 初期値としてお気に入り状態を設定
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: contentId, contentType: type.contentType))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                // お気に入りボタン - ピンク枠で囲む
                Button {
                    isLiked.toggle()
                    favoriteManager.toggleFavorite(id: contentId, contentType: type.contentType)
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .pink : .gray)
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            
            // プレビュー画像
            GeometryReader { geo in
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.75) // 実際のサイズより小さめに表示
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // フッター
            VStack(spacing: 15) {
                // いいね情報
                HStack(spacing: 20) {
                    // 表示回数
                    HStack(spacing: 5) {
                        Image(systemName: "eye.fill")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(favoriteManager.getViewCount(id: contentId))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    // いいね数
                    HStack(spacing: 5) {
                        Image(systemName: "heart.fill")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(favoriteManager.getFavorites(contentType: type.contentType).count)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                // タイトルとクリエイター
                VStack(spacing: 5) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("Created by")
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.gray)
                        Text("Wallpaper HD")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                // アクションボタン
                HStack(spacing: 20) {
                    // いいねボタン
                    Button {
                        isLiked.toggle()
                        favoriteManager.toggleFavorite(id: contentId, contentType: type.contentType)
                    } label: {
                        VStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .red : .black)
                            Text("")
                        }
                        .frame(width: 60, height: 60)
                    }
                    
                    // ブックマークボタン
                    Button {
                        // ブックマーク処理
                    } label: {
                        VStack {
                            Image(systemName: "bookmark")
                                .font(.title2)
                                .foregroundColor(.black)
                            Text("")
                        }
                        .frame(width: 60, height: 60)
                    }
                    
                    // 設定ボタン（ダウンロード）
                    Button {
                        downloadWallpaper()
                    } label: {
                        Text("設定")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    .disabled(downloadManager.isDownloading)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
            
            // ダウンロード進捗表示
            if downloadManager.isDownloading {
                ProgressView(value: downloadManager.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
            }
        }
        .alert("保存完了", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(type == .wallpaper ? "壁紙を写真に保存しました" : "ロック画面を写真に保存しました")
        }
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: contentId)
        }
    }
    
    private func downloadWallpaper() {
        Task {
            do {
                try await downloadManager.downloadWallpaper(imageUrl)
                
                // ダウンロード数を増やす
                favoriteManager.incrementDownloadCount(id: contentId)
                
                // ダウンロード履歴に追加
                let historyItem = DownloadHistoryItem(
                    itemId: contentId,
                    title: title,
                    imageUrl: imageUrl,
                    contentType: type.contentType
                )
                favoriteManager.addToDownloadHistory(item: historyItem)
                
                showingAlert = true
            } catch {
                // エラー処理はすでにダウンロードマネージャ内で行われています
            }
        }
    }
}
