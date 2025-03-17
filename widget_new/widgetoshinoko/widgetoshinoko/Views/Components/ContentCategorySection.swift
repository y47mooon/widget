import SwiftUI

struct ContentCategorySection<Category: CategoryType>: View {
    let title: String
    let items: [ContentItem<Category>]
    let category: Category
    let contentType: ContentType
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // ヘッダー
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                if !isExpanded {
                    NavigationLink(
                        destination: ContentListView(category: category, contentType: contentType)
                    ) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            
            // コンテンツ
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        ContentItemView(
                            item: item,
                            contentType: contentType,
                            index: index
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// コンテンツアイテムビュー
struct ContentItemView<Category: CategoryType>: View {
    let item: ContentItem<Category>
    let contentType: ContentType
    let index: Int
    let isInList: Bool
    
    init(item: ContentItem<Category>, contentType: ContentType, index: Int, isInList: Bool = false) {
        self.item = item
        self.contentType = contentType
        self.index = index
        self.isInList = isInList
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(width: isInList ? listItemWidth : homeItemWidth, height: isInList ? UIScreen.main.bounds.height * 0.45 : UIScreen.main.bounds.height * 0.3)
    }
    
    private var homeItemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 15
        return (screenWidth - padding - (spacing * 2)) / 3
    }
    
    private var listItemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 16
        return (screenWidth - padding - spacing) / 2
    }
}
