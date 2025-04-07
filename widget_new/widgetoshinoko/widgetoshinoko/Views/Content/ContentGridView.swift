import SwiftUI
import GaudiyWidgetShared

struct ContentGridView<Category: CategoryType>: View {
    let items: [ContentItem<Category>]
    let contentType: GaudiyContentType
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    init(items: [ContentItem<Category>], contentType: GaudiyContentType) {
        self.items = items
        self.contentType = contentType
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    NavigationLink(destination: ContentPreviewView(
                        imageUrl: item.imageUrl, 
                        title: item.title,
                        contentId: item.id,
                        contentType: contentType
                    )) {
                        ContentGridItemView(item: item)
                    }
                }
            }
            .padding()
        }
    }
}

struct ContentGridItemView<Category: CategoryType>: View {
    let item: ContentItem<Category>
    
    var body: some View {
        AsyncImage(url: URL(string: item.imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
        .clipped()
    }
}
