import SwiftUI

struct IconCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(IconCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.displayName,
                        items: viewModel.getIconItems(for: category),
                        destination: IconListView(category: category),
                        itemBuilder: { item, index in
                            if let iconSet = item as? IconSet {
                                AnyView(
                                    IconSetView(
                                        iconSet: iconSet,
                                        isLargeStyle: category == .newItems
                                    )
                                )
                            } else {
                                AnyView(
                                    Text("アイコンデータが無効です")
                                        .frame(width: 100, height: 100)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                )
                            }
                        }
                    )
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("アイコン")
    }
}

// プレビュー用
#Preview {
    NavigationView {
        IconCategoryListView(viewModel: MainContentViewModel())
    }
}

