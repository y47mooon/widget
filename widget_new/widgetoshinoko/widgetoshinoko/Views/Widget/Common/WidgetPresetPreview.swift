import SwiftUI
import GaudiyWidgetShared

struct WidgetPresetPreviewView: View {
    let title: String
    let description: String
    let previewContent: AnyView
    let preset: WidgetPreset
    var onComplete: (() -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSuccessAlert = false
    @State private var isLiked: Bool
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    
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
                
                Text("プレビュー")
                    .font(.headline)
                
                Spacer()
            }
            .padding()
            
            // プレビュー内容
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                
                previewContent
            }
            .padding(.horizontal)
            
            // 統計情報
            HStack(spacing: 20) {
                HStack(spacing: 5) {
                    Image(systemName: "eye")
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getViewCount(id: preset.id))")
                        .foregroundColor(.gray)
                }
                
                // お気に入り数
                HStack(spacing: 5) {
                    Image(systemName: "heart")
                        .foregroundColor(.gray)
                    Text("\(favoriteManager.getFavorites(contentType: .widget).count)")
                        .foregroundColor(.gray)
                }
                
                Text("\(favoriteManager.getDownloadCount(id: preset.id))")
                    .foregroundColor(.gray)
            }
            .padding(.top, 12)
            
            // タイトルと作者情報
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.top, 2)
                
                HStack {
                    Text("Created by")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(.gray)
                    
                    Text("公式")
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                    Spacer()
                    
                    // お気に入りボタン - ピンク枠で囲む
                    Button(action: {
                        // お気に入り状態を切り替え
                        isLiked.toggle()
                        favoriteManager.toggleFavorite(id: preset.id, contentType: .widget)
                    }) {
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
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 8)
            
            Spacer()
            
            // 設定ボタン
            NavigationLink(destination: 
                WidgetSetupView(preset: preset, onComplete: {
                    // ウィジェット追加時の処理
                    favoriteManager.incrementDownloadCount(id: preset.id)
                    
                    // ダウンロード履歴に追加
                    let historyItem = DownloadHistoryItem(
                        itemId: preset.id,
                        title: preset.title,
                        imageUrl: preset.imageUrl,
                        contentType: .widget
                    )
                    favoriteManager.addToDownloadHistory(item: historyItem)
                    
                    // 設定完了時の処理
                    showingSuccessAlert = true
                    // カスタムコールバックがあれば実行
                    onComplete?()
                })
                .navigationBarBackButtonHidden(false)
            ) {
                Text("設定")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink) // ピンク色に変更
                    .cornerRadius(12)
            }
            .padding([.horizontal, .bottom], 16)
        }
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("設定完了"),
                message: Text("ウィジェットの設定が完了しました。ホーム画面に戻り、ウィジェットを追加してください。"),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: preset.id)
        }
    }
    
    // イニシャライザを修正
    init(title: String, description: String, previewContent: AnyView, preset: WidgetPreset, onComplete: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.previewContent = previewContent
        self.preset = preset
        self.onComplete = onComplete
        
        // お気に入り状態を初期化
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: preset.id, contentType: .widget))
    }
}

// より簡単に初期化できるイニシャライザを追加
extension WidgetPresetPreviewView {
    init(preset: WidgetPreset, onComplete: (() -> Void)? = nil) {
        self.title = preset.title
        self.description = preset.description
        self.preset = preset
        self.onComplete = onComplete
        
        // お気に入り状態を初期化
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: preset.id, contentType: .widget))
        
        // プレセットタイプに基づいたプレビューコンテンツを作成
        if preset.type == .analogClock {
            self.previewContent = AnyView(
                ClockWidgetView(
                    size: preset.size,
                    configuration: preset.toClockConfiguration()
                )
                .frame(width: preset.size.previewWidth, height: preset.size.previewHeight)
            )
        } else if preset.type == .digitalClock {
            // デジタル時計ウィジェットは統一された表示
            self.previewContent = AnyView(
                VStack {
                    Text("13:52")
                        .font(.system(size: 48, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                }
                .frame(width: preset.size.previewWidth, height: preset.size.previewHeight)
            )
        } else if preset.type == .calendar {
            // カレンダーウィジェットは日付を統一
            self.previewContent = AnyView(
                VStack {
                    Text("2025年4月7日")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(width: preset.size.previewWidth, height: preset.size.previewHeight)
                .background(Color.white)
                .cornerRadius(12)
            )
        } else {
            // その他のタイプ（画像など）
            self.previewContent = AnyView(
                AsyncImage(url: URL(string: preset.imageUrl)) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image): image.resizable().aspectRatio(contentMode: .fit)
                    case .failure: Image(systemName: "photo").font(.largeTitle)
                    @unknown default: EmptyView()
                    }
                }
                .frame(width: preset.size.previewWidth, height: preset.size.previewHeight)
            )
        }
    }
}
