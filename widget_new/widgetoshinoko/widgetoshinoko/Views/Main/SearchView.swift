import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedCategory = 0
    
    let categories = ["全て", "テンプレート", "ウィジェット", "アイコン", "壁紙", "ロック画面"]
    
    var body: some View {
        NavigationView {
            VStack {
                // 検索バー
                SearchBar(text: $searchText)
                    .padding()
                
                // カテゴリー選択
                CategoryScrollView(selectedCategory: $selectedCategory, 
                                categories: categories)
                
                // 検索結果
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
            .navigationTitle("検索")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("検索", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
