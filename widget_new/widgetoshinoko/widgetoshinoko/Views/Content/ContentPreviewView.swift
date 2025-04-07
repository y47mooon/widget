import SwiftUI
import GaudiyWidgetShared

struct ContentPreviewView: View {
    let imageUrl: String
    let title: String
    let contentId: UUID
    let contentType: GaudiyContentType
    
    @StateObject private var downloadManager = ContentDownloadManager.shared
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    // 初期化時にお気に入り状態を設定
    @State private var isLiked: Bool
    
    init(imageUrl: String, title: String, contentId: UUID, contentType: GaudiyContentType) {
        self.imageUrl = imageUrl
        self.title = title
        self.contentId = contentId
        self.contentType = contentType
        
        // 初期値としてお気に入り状態を設定
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: contentId, contentType: contentType))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                // お気に入りボタン - ピンク枠で囲む
                Button {
                    isLiked.toggle()
                    favoriteManager.toggleFavorite(id: contentId, contentType: contentType)
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
                            .frame(maxWidth: .infinity)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // 統計情報
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
                
                // お気に入り数
                HStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getFavorites(contentType: contentType).count)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                // ダウンロード数
                HStack(spacing: 5) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getDownloadCount(id: contentId))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // タイトルとクリエイター
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Created by")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(.gray)
                    
                    Text("公式")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Spacer()
            
            // ダウンロードボタン
            Button(action: {
                downloadContent()
            }) {
                Text("設定")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(12)
            }
            .disabled(downloadManager.isDownloading)
            .padding([.horizontal, .bottom], 16)
            
            // ダウンロード進捗表示
            if downloadManager.isDownloading {
                ProgressView(value: downloadManager.progress) {
                    Text("\(Int(downloadManager.progress * 100))%")
                }
                .padding(.horizontal)
            }
            
            if let errorMessage = downloadManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("保存完了", isPresented: $showingAlert) {
            Button("OK") { 
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("写真アプリに保存しました")
        }
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: contentId)
        }
    }
    
    private func downloadContent() {
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
                    contentType: contentType
                )
                favoriteManager.addToDownloadHistory(item: historyItem)
                
                showingAlert = true
            } catch {
                // エラー処理はすでにダウンロードマネージャ内で行われています
            }
        }
    }
}

// プレビュー画像用のサブビュー
private struct PreviewImageView: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
            @unknown default:
                EmptyView()
            }
        }
    }
}

// コントロール部分用のサブビュー
private struct ControlsView: View {
    let title: String
    let imageUrl: String
    @ObservedObject var downloadManager: ContentDownloadManager
    @Binding var showingAlert: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
            
            DownloadButton(
                downloadManager: downloadManager,
                imageUrl: imageUrl,
                showingAlert: $showingAlert
            )
        }
    }
}

// ダウンロードボタン用のサブビュー
private struct DownloadButton: View {
    @ObservedObject var downloadManager: ContentDownloadManager
    let imageUrl: String
    @Binding var showingAlert: Bool
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await downloadManager.downloadWallpaper(imageUrl)
                    showingAlert = true
                } catch {
                    // エラー処理
                }
            }
        }) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                Text("保存する")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(downloadManager.isDownloading)
        .padding(.horizontal)
    }
}

// 進捗表示用のサブビュー
private struct ProgressIndicatorView: View {
    @ObservedObject var downloadManager: ContentDownloadManager
    
    var body: some View {
        VStack {
            if downloadManager.isDownloading {
                ProgressView(value: downloadManager.progress) {
                    Text("\(Int(downloadManager.progress * 100))%")
                }
                .padding(.horizontal)
            }
            
            if let errorMessage = downloadManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}
