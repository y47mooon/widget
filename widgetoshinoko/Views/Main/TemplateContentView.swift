import SwiftUI

struct TemplateContentView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(TemplateCategory.allCases, id: \.self) { category in
                    GenericSectionView(
                        title: category.rawValue,
                        items: viewModel.getTemplateItems(for: category), // 改善：カテゴリー別データを使用
                        destination: ContentListView(
                            category: category,
                            contentType: .template
                        ),
                        itemBuilder: { item, index in
                            AnyView(
                                ContentItemView(
                                    item: item,
                                    contentType: .template,
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
    TemplateContentView(viewModel: MainContentViewModel())
}
