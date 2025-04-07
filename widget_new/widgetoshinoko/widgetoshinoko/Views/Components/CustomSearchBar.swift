import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "検索"
    var onSubmit: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField(placeholder, text: $searchText)
                .padding(7)
                .onSubmit {
                    onSubmit?()
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    CustomSearchBar(searchText: .constant("テスト検索"))
}
