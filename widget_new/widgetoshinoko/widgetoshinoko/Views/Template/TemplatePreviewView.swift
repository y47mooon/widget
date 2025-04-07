import SwiftUI
import GaudiyWidgetShared

struct TemplatePreviewView: View {
    let template: TemplateItem
    let contentId: UUID
    
    @StateObject private var downloadManager = ContentDownloadManager.shared
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @State private var isLiked: Bool
    @State private var showApplyOptions = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    // 初期化時にお気に入り状態を設定
    init(template: TemplateItem, contentId: UUID) {
        self.template = template
        self.contentId = contentId
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: contentId, contentType: .template))
    }
    
    var body: some View {
        ScrollView {
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
                    
                    Text(template.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    // お気に入りボタン - ピンク枠で囲む
                    Button {
                        isLiked.toggle()
                        favoriteManager.toggleFavorite(id: contentId, contentType: .template)
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
                
                // テンプレートプレビュー画像
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
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // 統計情報
                HStack(spacing: 20) {
                    // 閲覧数
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
                        Text("\(favoriteManager.getFavorites(contentType: .template).count)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 12)
                
                // 使用中のウィジェットセクション
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("使用されているウィジェット")
                            .font(.headline)
                            .padding(.leading)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(template.usedWidgets) { widget in
                                WidgetItemView(item: widget)
                                    .frame(width: 120, height: 120)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 140)
                }
                .padding(.vertical, 12)
                
                // 壁紙ダウンロードボタン
                Button {
                    downloadWallpaper()
                } label: {
                    HStack {
                        Image(systemName: "photo.fill")
                        Text("壁紙をダウンロード")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // アイコンセットセクション
                if !template.iconSets.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("アイコンセット")
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(template.iconSets) { iconSet in
                                    IconSetView(iconSet: iconSet)
                                        .frame(width: 120, height: 120)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 140)
                    }
                    .padding(.vertical, 12)
                    
                    // アイコン設定ボタン
                    Button {
                        setupIcons()
                    } label: {
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                            Text("アイコンを設定")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                }
                
                // その他のアクションボタン
                HStack(spacing: 20) {
                    // いいねボタン
                    Button {
                        isLiked.toggle()
                        favoriteManager.toggleFavorite(id: contentId, contentType: .template)
                    } label: {
                        VStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .red : .black)
                            Text("お気に入り")
                                .font(.caption)
                        }
                        .frame(width: 80, height: 80)
                    }
                    
                    // 保存ボタン
                    Button {
                        // テンプレート保存処理
                    } label: {
                        VStack {
                            Image(systemName: "bookmark")
                                .font(.title2)
                                .foregroundColor(.black)
                            Text("保存")
                                .font(.caption)
                        }
                        .frame(width: 80, height: 80)
                    }
                    
                    // 共有ボタン
                    Button {
                        // 共有処理
                    } label: {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.black)
                            Text("共有")
                                .font(.caption)
                        }
                        .frame(width: 80, height: 80)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: contentId)
        }
    }
    
    // 壁紙をダウンロード
    private func downloadWallpaper() {
        Task {
            do {
                try await downloadManager.downloadWallpaper(template.imageUrl)
                
                // ダウンロード数を増やす
                favoriteManager.incrementDownloadCount(id: contentId)
                
                // ダウンロード履歴に追加
                let historyItem = DownloadHistoryItem(
                    itemId: contentId,
                    title: template.title,
                    imageUrl: template.imageUrl,
                    contentType: .template
                )
                favoriteManager.addToDownloadHistory(item: historyItem)
                
                alertMessage = "壁紙を保存しました。写真アプリから設定できます。"
                showingAlert = true
            } catch {
                alertMessage = "壁紙の保存に失敗しました。"
                showingAlert = true
            }
        }
    }
    
    // アイコンを設定
    private func setupIcons() {
        // プロファイル設定が必要なアイコンがあるか確認
        let hasProfileIcons = template.iconSets.flatMap { $0.icons }.contains { $0.targetAppBundleId != nil }
        
        if hasProfileIcons {
            // プロファイル設定が必要なアイコンがある場合
            showIconProfileSetup()
        } else {
            // 通常のアイコン画像ダウンロードのみ
            downloadIconImages()
        }
    }
    
    // アイコンプロファイル設定
    private func showIconProfileSetup() {
        // すべてのアイコンからIconConfigItemを作成
        let iconItems = template.iconSets.flatMap { iconSet in
            iconSet.icons.map { icon in
                IconConfigItem.from(icon: icon, title: "\(template.title) - \(iconSet.title)")
            }
        }
        
        // UIKit ViewControllerを取得してプロファイル共有
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            alertMessage = "アイコンプロファイルの共有に失敗しました。"
            showingAlert = true
            return
        }
        
        IconProfileGenerator.shared.shareProfile(icons: iconItems, from: rootViewController) { success in
            if success {
                // プロファイル共有に成功した場合
                alertMessage = "アイコンプロファイルを共有しました。設定アプリからインストールしてください。"
            } else {
                // キャンセルまたは失敗した場合
                alertMessage = "アイコンプロファイルの共有をキャンセルしました。"
            }
            
            // メインスレッドでアラートを表示
            DispatchQueue.main.async {
                showingAlert = true
            }
        }
    }
    
    // アイコン画像をダウンロード
    private func downloadIconImages() {
        Task {
            var successCount = 0
            let totalCount = template.iconSets.reduce(0) { $0 + $1.icons.count }
            
            for iconSet in template.iconSets {
                for icon in iconSet.icons {
                    do {
                        // アイコン画像をダウンロード
                        try await downloadManager.downloadWallpaper(icon.imageUrl)
                        successCount += 1
                    } catch {
                        // エラーは無視して続行
                    }
                }
            }
            
            // 結果を表示
            if successCount > 0 {
                alertMessage = "\(successCount)/\(totalCount)個のアイコンを保存しました。写真アプリから確認できます。"
            } else {
                alertMessage = "アイコンの保存に失敗しました。"
            }
            
            showingAlert = true
        }
    }
}

// テンプレートアイテム拡張
extension TemplateItem {
    // 使用されているウィジェット（デモデータ）
    var usedWidgets: [WidgetItem] {
        return [
            WidgetItem(
                title: "シンプル時計",
                description: "シンプルなデジタル時計",
                imageUrl: "",
                category: WidgetCategory.clock.rawValue
            ),
            WidgetItem(
                title: "カレンダー",
                description: "今日の日付を表示",
                imageUrl: "",
                category: WidgetCategory.calendar.rawValue
            ),
            WidgetItem(
                title: "天気予報",
                description: "現在地の天気",
                imageUrl: "",
                category: WidgetCategory.weather.rawValue
            )
        ]
    }
    
    // アイコンセット（デモデータ）
    var iconSets: [IconSet] {
        return [
            IconSet(
                id: UUID(),
                title: "基本アイコン",
                icons: [
                    IconSet.Icon(id: UUID(), imageUrl: "", targetAppBundleId: "com.apple.MobileSMS"),
                    IconSet.Icon(id: UUID(), imageUrl: "", targetAppBundleId: "com.apple.mobilephone"),
                    IconSet.Icon(id: UUID(), imageUrl: "", targetAppBundleId: "com.apple.mobilesafari"),
                    IconSet.Icon(id: UUID(), imageUrl: "", targetAppBundleId: "com.apple.camera")
                ],
                category: .popular,
                popularity: 100,
                createdAt: Date()
            )
        ]
    }
}

// テンプレート適用オプション画面
struct TemplateApplyOptionsView: View {
    let title: String
    let imageUrl: String
    let onComplete: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @StateObject private var downloadManager = ContentDownloadManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // 壁紙として適用
                    Button {
                        applyAsWallpaper()
                    } label: {
                        HStack {
                            Image(systemName: "photo")
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            Text("壁紙として適用")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .disabled(downloadManager.isDownloading)
                    
                    // ロック画面として適用
                    Button {
                        applyAsLockScreen()
                    } label: {
                        HStack {
                            Image(systemName: "lock")
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            Text("ロック画面として適用")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .disabled(downloadManager.isDownloading)
                    
                    // ウィジェット背景として適用
                    Button {
                        applyAsWidgetBackground()
                    } label: {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            Text("ウィジェット背景として適用")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .disabled(downloadManager.isDownloading)
                }
                .listStyle(InsetGroupedListStyle())
                
                // 進捗表示
                if downloadManager.isDownloading {
                    VStack {
                        ProgressView(value: downloadManager.progress)
                            .progressViewStyle(LinearProgressViewStyle())
                        Text("ダウンロード中...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
            .navigationTitle("適用先を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // テンプレートを壁紙として適用
    private func applyAsWallpaper() {
        Task {
            do {
                try await downloadManager.downloadWallpaper(imageUrl)
                onComplete("壁紙として保存しました。写真アプリから設定できます。")
            } catch {
                onComplete("壁紙の保存に失敗しました。")
            }
        }
    }
    
    // テンプレートをロック画面として適用
    private func applyAsLockScreen() {
        Task {
            do {
                try await downloadManager.downloadWallpaper(imageUrl)
                onComplete("ロック画面として保存しました。写真アプリから設定できます。")
            } catch {
                onComplete("ロック画面の保存に失敗しました。")
            }
        }
    }
    
    // テンプレートをウィジェット背景として適用
    private func applyAsWidgetBackground() {
        // この部分はウィジェット背景設定のための処理
        // 実際の実装はプロジェクトの要件に合わせる
        dismiss()
        onComplete("ウィジェット背景として適用しました。")
    }
}

// プレビュー
struct TemplatePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatePreviewView(
            template: TemplateItem(
                id: UUID(),
                title: "モダンテンプレート",
                imageUrl: "https://example.com/image.jpg"
            ),
            contentId: UUID()
        )
    }
}
