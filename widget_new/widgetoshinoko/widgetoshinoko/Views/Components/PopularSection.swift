import SwiftUI

struct PopularSection: View {
    let title: String
    let items: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Text("もっとみる")
                        .font(.system(size: 14))
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
