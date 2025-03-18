import SwiftUI

struct GenericSectionView<Item, Destination: View>: View {
    // プロパティ
    let title: String
    let items: [Item]
    let destination: Destination
    let itemsPerRow: Int
    let itemBuilder: (Item, Int) -> AnyView
    
    // 初期化
    init(
        title: String,
        items: [Item],
        destination: Destination,
        itemsPerRow: Int = 1,
        @ViewBuilder itemBuilder: @escaping (Item, Int) -> AnyView
    ) {
        self.title = title
        self.items = items
        self.destination = destination
        self.itemsPerRow = itemsPerRow
        self.itemBuilder = itemBuilder
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // ヘッダー
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                NavigationLink(destination: destination) {
                    HStack {
                        Text("もっと見る")
                            .font(.system(size: 14))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            // コンテンツ
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        itemBuilder(item, index)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// プレビュー
#Preview {
    NavigationView {
        GenericSectionView(
            title: "サンプルセクション",
            items: [1, 2, 3, 4, 5],
            destination: Text("詳細ビュー"),
            itemBuilder: { item, index in
                AnyView(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 160, height: 80)
                        .overlay(Text("\(item)"))
                )
            }
        )
    }
}
