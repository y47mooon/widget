import SwiftUI
import GaudiyWidgetShared
import Foundation

/// テンプレートの簡易プレビュービュー
/// 壁紙やロック画面と同様のプレビュー表示フロー
struct TemplateSimplePreviewView: View {
    let template: TemplateItem
    
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var currentImage = 0
    
    // 初期化時にお気に入り状態を設定
    @State private var isLiked: Bool
    
    init(template: TemplateItem) {
        self.template = template
        // 初期値としてお気に入り状態を設定
        _isLiked = State(initialValue: FavoriteManager.shared.isFavorite(id: template.id, contentType: .template))
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
            
            // プレビュー画像（スライド機能付き）
            GeometryReader { geo in
                if let images = template.images, images.count > 1 {
                    // 複数画像の場合はスライド表示
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
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                } else {
                    // 単一画像の場合はスクロールなし
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
                }
            }
            .frame(height: 400)
            
            // フッター
            VStack(spacing: 15) {
                // いいね情報
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
                    
                    // いいね数
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
                
                // タイトルとクリエイター
                VStack(spacing: 5) {
                    Text(template.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("template_created_by".localized)
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.gray)
                        Text("公式")
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
                        favoriteManager.toggleFavorite(id: template.id, contentType: .template)
                    } label: {
                        VStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .red : .black)
                            Text("")
                        }
                        .frame(width: 60, height: 60)
                    }
                    
                    // 設定ボタン（詳細画面へ遷移）
                    NavigationLink(destination: TemplatePreviewView(template: template)) {
                        Text("設定")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .onAppear {
            // 表示回数を増やす
            favoriteManager.incrementViewCount(id: template.id)
        }
    }
}

// プレビュー
#Preview {
    NavigationView {
        TemplateSimplePreviewView(
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
