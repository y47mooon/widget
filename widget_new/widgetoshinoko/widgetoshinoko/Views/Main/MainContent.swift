import SwiftUI

struct MainContentView: View {
    @Binding var selectedCategory: Int
    let categories: [String]
    let filterTags: [String]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CategoryScrollView(selectedCategory: $selectedCategory, 
                                categories: categories)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filterTags, id: \.self) { tag in
                            FilterChipView(title: tag)
                        }
                    }
                    .padding(.horizontal)
                }
                
                PopularSection(title: "人気のホーム画面", items: 4)
                PopularSection(title: "人気のウィジェット", items: 3)
                PopularSection(title: "人気のロック画面", items: 4)
            }
        }
    }
}

#Preview {
    @State var selectedCategory = 0
    let categories = ["全て", "テンプレート", "ウィジェット", "アイコン", "壁紙", "ロック画面"]
    let filterTags = ["おしゃれ", "シンプル", "白", "モノクロ", "かわいい", "きれい"]
    
    return MainContentView(
        selectedCategory: $selectedCategory,
        categories: categories,
        filterTags: filterTags
    )
}
