import SwiftUI

struct CategoryDetailView: View {
    let title: String
    let spacing: CGFloat = 16
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(0..<10) { index in
                    // 固定の縦幅を使用
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: UIScreen.main.bounds.height * 0.35) // 画面高さの35%
                        .overlay(
                            // 実際の画像がある場合はここに表示
                            Image("placeholder")
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        )
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationView {
        CategoryDetailView(title: "カテゴリー詳細")
    }
}
