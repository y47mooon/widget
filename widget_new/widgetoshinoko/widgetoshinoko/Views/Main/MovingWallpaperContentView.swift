import SwiftUI

struct MovingWallpaperContentView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(MovingWallpaperCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getMovingWallpaperItems(for: category),
                        destination: ContentListView(
                            category: category,
                            contentType: .movingWallpaper
                        ),
                        itemBuilder: { item, index in
                            AnyView(
                                ContentItemView(
                                    item: item,
                                    contentType: .movingWallpaper,
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
    MovingWallpaperContentView(viewModel: MainContentViewModel())
}
