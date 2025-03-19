import SwiftUI

struct IconListView: View {
    let category: IconCategory
    @StateObject private var viewModel: IconListViewModel
    
    // 画面幅に基づいてアイテムサイズを計算
    private var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 8 * 2 // 左右の余白
        let spacing: CGFloat = 8 // アイテム間の余白
        return (screenWidth - padding - spacing) / 2 // 2列で表示
    }
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]
    }
    
    init(category: IconCategory) {
        self.category = category
        self._viewModel = StateObject(wrappedValue: IconListViewModel(category: category))
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.items) { iconSet in
                    IconSetView(
                        iconSet: iconSet,
                        isLargeStyle: category == .new,
                        isInList: true
                    )
                    .frame(width: itemWidth, height: itemWidth) // 正方形で表示
                }
            }
            .padding(.horizontal, 8)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .navigationTitle(category.rawValue)
        .task {
            await viewModel.loadInitialItems()
        }
    }
}

#Preview {
    NavigationView {
        IconListView(category: .popular)
    }
}
