import SwiftUI

struct WidgetCategorySection<Destination: View>: View {
    let title: String
    let items: Int
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                NavigationLink(destination: destination) {
                    HStack {
                        Text("もっと見る")
                            .font(.system(size: 14))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<items, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 160, height: 80)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NavigationView {
        WidgetCategorySection(
            title: "人気のウィジェット",
            items: 3,
            destination: Text("詳細ビュー")
        )
    }
}
