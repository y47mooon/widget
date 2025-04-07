import SwiftUI
import GaudiyWidgetShared

struct ContentListView: View {
    let category: String?
    let contentType: GaudiyContentType
    @StateObject private var viewModel: ContentListViewModel
    
    init(category: String? = nil, contentType: GaudiyContentType) {
        self.category = category
        self.contentType = contentType
        _viewModel = StateObject(wrappedValue: ContentListViewModel())
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ForEach(viewModel.contents) { content in
                    FirebaseContentItemView(content: content)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(category ?? "すべてのコンテンツ")
        .task {
            await viewModel.loadContents(category: category)
        }
    }
}

struct FirebaseContentItemView: View {
    let content: Content
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: content.previewImageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            
            Text(content.description)
                .lineLimit(2)
                .padding(.horizontal)
            
            if !content.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(content.tags, id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}