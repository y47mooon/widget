import SwiftUI
import GaudiyWidgetShared

struct WidgetPreviewView: View {
    let preset: WidgetPreset
    let size: WidgetSize
    @State private var isLiked: Bool
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    var onComplete: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー部分
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
            
            // プレビュー画像/ウィジェット - 統一されたデザイン
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                
                if preset.type == .analogClock {
                    // 時計ウィジェット表示
                    ClockWidgetView(
                        size: size,
                        configuration: preset.toClockConfiguration()
                    )
                    .frame(width: size.previewWidth, height: size.previewHeight)
                } else if preset.type == .digitalClock {
                    // デジタル時計ウィジェット
                    Text("13:52")
                        .font(.system(size: 48, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                        .frame(width: size.previewWidth, height: size.previewHeight)
                } else if preset.type == .calendar {
                    // カレンダーウィジェット
                    VStack {
                        Text("2025年4月7日")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .frame(width: size.previewWidth, height: size.previewHeight)
                    .background(Color.white)
                    .cornerRadius(12)
                } else {
                    // その他のウィジェット
                    AsyncImage(url: URL(string: preset.imageUrl)) { phase in
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
                    .frame(width: size.previewWidth, height: size.previewHeight)
                }
            }
            
            // 統計情報
            HStack(spacing: 20) {
                // 閲覧数
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
            
            // タイトル情報
            Text(preset.title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 4)
            
            // 説明と作者
            HStack {
                Text("サンプルウィジェット")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Created by")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("公式")
                    .font(.caption)
                    .foregroundColor(.gray)
                    
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
            .padding(.horizontal)
            .padding(.bottom, 10)
            
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
                    
                    // 呼び出し元に完了通知
                    presentationMode.wrappedValue.dismiss()
                    onComplete?()
                })
                .navigationBarBackButtonHidden(false)
            ) {
                Text("設定")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 10)
        }
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: preset.id)
        }
    }
    
    init(preset: WidgetPreset, size: WidgetSize, onComplete: (() -> Void)? = nil) {
        self.preset = preset
        self.size = size
        self.onComplete = onComplete
        
        // お気に入り状態を初期化
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: preset.id, contentType: .widget))
    }
}

// ウィジェットサイズの拡張
extension WidgetSize {
    var previewScale: CGFloat {
        switch self {
        case .small: return 0.8
        case .medium: return 0.7
        case .large: return 0.6
        }
    }
    
    var previewWidth: CGFloat {
        return size.width * previewScale
    }
    
    var previewHeight: CGFloat {
        return size.height * previewScale
    }
}

struct WidgetPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // 適切なプレビューデータを提供
            WidgetPreviewView(
                preset: WidgetPreset(
                    id: UUID(),
                    title: "サンプルウィジェット",
                    description: "プレビュー用のサンプルウィジェットです",
                    type: .analogClock,
                    size: .medium,
                    style: "default",
                    imageUrl: "",
                    backgroundColor: nil,
                    requiresPurchase: false,
                    isPurchased: true,
                    configuration: [:]
                ),
                size: .medium
            )
        }
    }
}
