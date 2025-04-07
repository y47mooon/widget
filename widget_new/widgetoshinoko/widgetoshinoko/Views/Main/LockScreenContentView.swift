import SwiftUI

struct LockScreenContentView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            // すべてのロック画面カテゴリーを表示
            VStack(spacing: 24) {
                ForEach(LockScreenCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getLockScreenItems(for: category),
                        destination: ContentListView(
                            category: category.rawValue,
                            contentType: .lockScreen
                        ),
                        itemBuilder: { item, index in
                            AnyView(
                                ContentItemView(
                                    item: item,
                                    contentType: .lockScreen,
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
    LockScreenContentView(viewModel: MainContentViewModel())
}
