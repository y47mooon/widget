import SwiftUI
import GaudiyWidgetShared

struct IconSetView: View {
    let iconSet: IconSet
    let maxDisplayIcons: Int = 4
    let isLargeStyle: Bool
    let isInList: Bool
    
    init(iconSet: IconSet, isLargeStyle: Bool = false, isInList: Bool = false) {
        self.iconSet = iconSet
        self.isLargeStyle = isLargeStyle
        self.isInList = isInList
    }
    
    var body: some View {
        if isLargeStyle {
            // 単一アイコン表示（外枠なし）
            largeSingleIconView
        } else if isInList {
            // もっと見る展開後のレイアウト
            listLayoutView
        } else {
            // 展開前のレイアウト（元のまま）
            gridLayoutView
        }
    }
    
    // 大きい単一アイコン表示
    private var largeSingleIconView: some View {
        Group {
            if let firstIcon = iconSet.icons.first {
                AsyncImage(url: URL(string: firstIcon.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "app")
                            .font(.system(size: 30))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: itemWidth, height: itemWidth)
                .cornerRadius(12)
            } else if !iconSet.previewUrl.isEmpty {
                // プレビュー画像がある場合はそれを表示
                AsyncImage(url: URL(string: iconSet.previewUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "app")
                            .font(.system(size: 30))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: itemWidth, height: itemWidth)
                .cornerRadius(12)
            } else {
                // イメージがない場合のプレースホルダー
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: itemWidth, height: itemWidth)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "app")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    )
            }
        }
    }
    
    // リスト表示用レイアウト
    private var listLayoutView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<min(2, iconSet.icons.count), id: \.self) { index in
                    let icon = iconSet.icons[index]
                    loadIconImage(from: icon.imageUrl)
                        .padding(4)
                }
                // 要素が足りない場合のプレースホルダー
                if iconSet.icons.count < 2 {
                    ForEach(0..<(2 - iconSet.icons.count), id: \.self) { _ in
                        placeholderIcon
                            .padding(4)
                    }
                }
            }
            HStack(spacing: 0) {
                if iconSet.icons.count > 2 {
                    ForEach(2..<min(4, iconSet.icons.count), id: \.self) { index in
                        let icon = iconSet.icons[index]
                        loadIconImage(from: icon.imageUrl)
                            .padding(4)
                    }
                }
                // 要素が足りない場合のプレースホルダー
                if iconSet.icons.count < 4 {
                    ForEach(0..<min(2, 4 - max(2, iconSet.icons.count)), id: \.self) { _ in
                        placeholderIcon
                            .padding(4)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .frame(height: itemHeight)
    }
    
    // グリッド表示用レイアウト
    private var gridLayoutView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.1))
            .overlay(
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)
                    ],
                    spacing: 8
                ) {
                    if iconSet.icons.isEmpty {
                        // アイコンがない場合はプレビュー画像を表示
                        if !iconSet.previewUrl.isEmpty {
                            AsyncImage(url: URL(string: iconSet.previewUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                case .failure:
                                    placeholderIcon
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(12)
                        } else {
                            // プレビュー画像もない場合はプレースホルダー
                            ForEach(0..<4, id: \.self) { _ in
                                placeholderIcon
                            }
                        }
                    } else {
                        // 通常のアイコン表示
                        ForEach(0..<min(maxDisplayIcons, iconSet.icons.count), id: \.self) { index in
                            let icon = iconSet.icons[index]
                            loadIconImage(from: icon.imageUrl)
                        }
                        // 足りない数のプレースホルダー
                        if iconSet.icons.count < maxDisplayIcons {
                            ForEach(0..<(maxDisplayIcons - iconSet.icons.count), id: \.self) { _ in
                                placeholderIcon
                            }
                        }
                    }
                }
                .padding(8)
            )
            .frame(width: itemWidth, height: itemHeight)
    }
    
    // プレースホルダーアイコン
    private var placeholderIcon: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(12)
            .overlay(
                Image(systemName: "app")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            )
    }
    
    // アイコン画像の読み込み
    private func loadIconImage(from url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(12)
                    .overlay(ProgressView())
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            case .failure:
                placeholderIcon
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 8
        let itemCount: CGFloat = 3.5 // 表示数を統一
        let totalSpacing = spacing * (itemCount - 1)
        
        return (screenWidth - padding - totalSpacing) / itemCount
    }
    
    private var itemWidth: CGFloat {
        if isInList {
            // リスト表示時のサイズ（ContentItemViewと同じ計算方法）
            let screenWidth = UIScreen.main.bounds.width
            let padding: CGFloat = 16 * 2
            let spacing: CGFloat = 16
            return (screenWidth - padding - spacing) / 2
        } else {
            // ホーム表示時のサイズ（既存の計算方法）
            return calculateWidth()
        }
    }
    
    private var itemHeight: CGFloat {
        isInList ? itemWidth * 1.2 : itemWidth
    }
}

// プレビュー用
#Preview {
    VStack {
        // グリッド表示
        IconSetView(
            iconSet: IconSet(
                id: UUID(),
                title: "基本アイコン",
                icons: (0..<4).map { i in
                    IconSet.Icon(
                        id: UUID(),
                        imageUrl: "https://picsum.photos/seed/icon\(i)/100",
                        targetAppBundleId: "com.apple.MobileSMS"
                    )
                }
            )
        )
        .frame(width: 150, height: 150)
        
        // 大きい表示
        IconSetView(
            iconSet: IconSet(
                id: UUID(),
                title: "シンプルアイコン",
                icons: [
                    IconSet.Icon(
                        id: UUID(),
                        imageUrl: "https://picsum.photos/seed/icon1/200",
                        targetAppBundleId: "com.apple.mobilesafari"
                    )
                ]
            ),
            isLargeStyle: true
        )
        .frame(width: 150, height: 150)
        
        // リスト表示
        IconSetView(
            iconSet: IconSet.previewOnly(
                title: "プレビューのみ",
                previewUrl: "https://picsum.photos/seed/preview/200"
            ),
            isInList: true
        )
        .frame(width: 200, height: 200)
    }
    .padding()
}
