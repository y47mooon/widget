import SwiftUI

struct IconCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(IconCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getIconItems(for: category),
                        destination: IconListView(category: category),
                        itemBuilder: { item, index in
                            AnyView(
                                IconSetView(
                                    iconSet: item as! IconSet,
                                    isLargeStyle: category == .new
                                )
                            )
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

