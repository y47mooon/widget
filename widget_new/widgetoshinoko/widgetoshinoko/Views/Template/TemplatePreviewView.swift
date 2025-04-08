import SwiftUI
import GaudiyWidgetShared
import Foundation

struct TemplatePreviewView: View {
    let template: TemplateItem
    
    @StateObject private var downloadManager = ContentDownloadManager.shared
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @State private var showingWallpaperOptions = false
    @State private var showingIconOptions = false
    @State private var showingAlert = false
    @State private var currentImage = 0
    
    // 初期化時にお気に入り状態を設定
    @State private var isLiked: Bool
    
    init(template: TemplateItem) {
        self.template = template
        // 初期値としてお気に入り状態を設定
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: template.id, contentType: .template))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // ヘッダーと画像プレビュー
                headerView
                
                // スライドインジケーター
                if template.images?.count ?? 0 > 1 {
                    pageIndicator
                        .padding(.top, 8)
                }
                
                // テンプレート情報
                templateInfoSection
                
                // 各種ボタン
                actionButtonsSection
                
                // ウィジェット・アイコン一覧
                if let widgets = template.widgets, !widgets.isEmpty {
                    usedWidgetsSection(widgets: widgets)
                }
                
                if let icons = template.icons, !icons.isEmpty {
                    usedIconsSection(icons: icons)
                }
                
                Spacer(minLength: 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            Group {
                if downloadManager.isDownloading {
                    downloadProgressView
                }
            }
        )
        .alert("保存完了", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text("写真アプリに保存しました")
        }
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: template.id)
        }
    }
    
    // ヘッダーとプレビュー画像
    private var headerView: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Text(template.title)
                    .font(.headline)
                
                Spacer()
                
                // お気に入りボタン
                Button {
                    isLiked.toggle()
                    favoriteManager.toggleFavorite(id: template.id, contentType: .template)
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
            if let images = template.images, !images.isEmpty {
                TabView(selection: $currentImage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        AsyncImage(url: URL(string: images[index])) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
            } else {
                // 単一の画像
                AsyncImage(url: URL(string: template.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 400)
            }
        }
    }
    
    // ページインジケーター
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            if let count = template.images?.count, count > 0 {
                ForEach(0..<count, id: \.self) { index in
                    Circle()
                        .fill(currentImage == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
    
    // テンプレート情報セクション
    private var templateInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // タイトルとクリエイター
            VStack(alignment: .leading, spacing: 5) {
                Text(template.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Text("template_created_by".localized)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(.gray)
                    
                    Text("公式")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // 説明文
            if let description = template.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            // 統計情報
            HStack(spacing: 20) {
                // 表示回数
                HStack(spacing: 5) {
                    Image(systemName: "eye.fill")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getViewCount(id: template.id))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                // お気に入り数
                HStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getFavorites(contentType: .template).count)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                // ダウンロード数
                HStack(spacing: 5) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getDownloadCount(id: template.id))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // アクションボタンセクション
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // ダウンロードボタン
            Button(action: downloadWallpaper) {
                Label("template_download_wallpaper".localized, systemImage: "arrow.down.circle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            // 動く壁紙があれば表示
            if template.hasMovingWallpaper {
                Button(action: downloadMovingWallpaper) {
                    Label("template_download_moving_wallpaper".localized, systemImage: "photo.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            // アイコンがあれば表示
            if template.hasIcons {
                Button(action: downloadIconProfile) {
                    Label("template_download_icons".localized, systemImage: "app.badge.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .disabled(downloadManager.isDownloading)
    }
    
    // 使用ウィジェットセクション
    private func usedWidgetsSection(widgets: [WidgetPreset]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("template_used_widgets".localized)
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(widgets) { widget in
                        NavigationLink(destination: WidgetPresetPreviewView(preset: widget)) {
                            VStack {
                                AsyncImage(url: URL(string: widget.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(12)
                                    case .failure:
                                        Image(systemName: "square.grid.2x2")
                                            .font(.system(size: 30))
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(12)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 80, height: 80)
                                
                                Text(widget.title)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .frame(width: 100)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    // 使用アイコンセクション
    private func usedIconsSection(icons: [IconSet]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("template_used_icons".localized)
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(icons, id: \.id) { icon in
                        VStack {
                            AsyncImage(url: URL(string: icon.previewUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(12)
                                case .failure:
                                    Image(systemName: "app")
                                        .font(.system(size: 30))
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 60, height: 60)
                            
                            Text(icon.title)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .frame(width: 80)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    // ダウンロード進捗表示
    private var downloadProgressView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                ProgressView(value: downloadManager.progress) {
                    Text("\(Int(downloadManager.progress * 100))%")
                        .font(.headline)
                }
                
                Text("ダウンロード中...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("キャンセル") {
                    downloadManager.cancelDownload()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding()
        }
    }
    
    // 壁紙ダウンロード処理
    private func downloadWallpaper() {
        let imageUrl = template.images?.first ?? template.imageUrl
        
        Task {
            do {
                try await downloadManager.downloadWallpaper(imageUrl)
                
                // ダウンロード数を増やす
                favoriteManager.incrementDownloadCount(id: template.id)
                
                // ダウンロード履歴に追加
                let historyItem = DownloadHistoryItem(
                    itemId: template.id,
                    title: template.title,
                    imageUrl: imageUrl,
                    contentType: .template
                )
                DownloadHistoryManager.shared.addToHistory(historyItem)
                
                showingAlert = true
            } catch {
                print("ダウンロードエラー: \(error)")
            }
        }
    }
    
    // 動く壁紙ダウンロード処理
    private func downloadMovingWallpaper() {
        // ここに動く壁紙ダウンロードの実装を追加
        print("動く壁紙をダウンロード")
    }
    
    // アイコンプロファイルダウンロード処理
    private func downloadIconProfile() {
        // ここにアイコンプロファイルのダウンロード実装を追加
        print("アイコンプロファイルをダウンロード")
    }
}

#Preview {
    NavigationView {
        TemplatePreviewView(
            template: TemplateItem(
                id: UUID(),
                title: "プレビューテンプレート",
                description: "これはプレビュー用のテンプレートです。素敵な壁紙とウィジェットのセットです。",
                imageUrl: "https://picsum.photos/400/800",
                category: .popular,
                popularity: 100
            )
        )
    }
}
