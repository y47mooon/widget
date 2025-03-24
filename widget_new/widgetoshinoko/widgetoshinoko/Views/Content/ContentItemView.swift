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
        let context: DisplayContext = {
            switch contentType {
            case .template: return .template
            case .icon: return .icon
            case .widget: return .widget
            case .lockScreen: return .home
            case .wallpaper: return .home
            case .movingWallpaper: return .home
            }
        }()
        
        RoundedRectangle(cornerRadius: DesignConstants.Layout.cornerRadius)
            .fill(DesignConstants.Colors.itemBackground)
            .contextFrame(for: context, isInList: isInList)
            .widgetTitleOverlay(item.title)
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
