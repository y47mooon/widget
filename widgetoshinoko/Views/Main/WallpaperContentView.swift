import SwiftUI

struct WallpaperContentView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(WallpaperCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getWallpaperItems(for: category),
                        destination: ContentListView(
                            category: category,
                            contentType: .wallpaper
                        ),
                        itemBuilder: { item, index in
                            AnyView(
                                ContentItemView(
                                    item: item,
                                    contentType: .wallpaper,
                                    index: index
                                )
                            )
                        }
                    )
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    WallpaperContentView(viewModel: MainContentViewModel())
}
