import SwiftUI

struct FavoritesView: View {
    @State private var selectedCategory = 0
    
    let categories = ["全て", "ホーム画面", "ウィジェット", "ロック画面"]
    
    var body: some View {
        NavigationView {
            VStack {
                // カテゴリー選択
                CategoryScrollView(selectedCategory: $selectedCategory, 
                                categories: categories)
                
                // お気に入りアイテム
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(0..<10) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 200)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("お気に入り")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
