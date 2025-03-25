import SwiftUI

struct GenericSectionView<T: Identifiable, Content: View>: View {
    // プロパティ
    let title: String
    let seeMoreText: String
    let items: [T]
    let destination: any View
    let itemBuilder: (T, Int) -> Content
    
    // 初期化
    init(
        title: String,
        seeMoreText: String = "button_see_more".localized,
        items: [T],
        destination: any View,
        @ViewBuilder itemBuilder: @escaping (T, Int) -> Content
    ) {
        self.title = title
        self.seeMoreText = seeMoreText
        self.items = items
        self.destination = destination
        self.itemBuilder = itemBuilder
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                NavigationLink(destination: AnyView(destination)) {
                    Text(seeMoreText)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
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
            seeMoreText: "もっと見る",
            items: [1, 2, 3, 4, 5].map { 
                PreviewItem(id: UUID(), value: $0) 
            },
            destination: AnyView(Text("詳細ビュー")),
            itemBuilder: { item, index in
                AnyView(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 160, height: 80)
                        .overlay(Text("\(item.value)"))
                )
            }
        )
    }
}

// プレビュー用のIdentifiableな構造体
private struct PreviewItem: Identifiable {
    let id: UUID
    let value: Int
}
