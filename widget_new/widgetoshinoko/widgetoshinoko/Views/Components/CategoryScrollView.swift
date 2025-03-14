import SwiftUI

struct CategoryScrollView: View {
    @Binding var selectedCategory: Int
    let categories: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(action: {
                        selectedCategory = index
                    }) {
                        Text(categories[index])
                            .foregroundColor(selectedCategory == index ? .pink : .gray)
                            .padding(.bottom, 5)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedCategory == index ? .pink : .clear)
                                    .offset(y: 4)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
