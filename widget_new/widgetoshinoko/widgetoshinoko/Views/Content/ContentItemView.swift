import SwiftUI

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

// プレビュー
#Preview {
    ContentItemView(
        item: ContentItem(
            title: "サンプルアイテム",
            imageUrl: "placeholder",
            category: TemplateCategory.popular,
            popularity: 100
        ),
        contentType: .template,
        index: 0
    )
}
