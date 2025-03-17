import SwiftUI

struct PopularSection<D: View>: View {
    let title: String
    let items: Int
    let destination: D
    
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
                            .frame(width: title.contains("ウィジェット") ? 200 : 150,
                                   height: title.contains("ウィジェット") ? 100 : 280)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NavigationView {
        PopularSection(
            title: "人気のウィジェット",
            items: 3,
            destination: Text("詳細ビュー")
        )
    }
}
