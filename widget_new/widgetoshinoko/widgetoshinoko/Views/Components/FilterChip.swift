import SwiftUI

struct FilterChipView: View {
    let title: String
    var isSelected: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            Text(title)
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.pink.opacity(0.1) : Color.white)
                        .overlay(
                            Capsule()
                                .strokeBorder(isSelected ? Color.pink : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
                .foregroundColor(isSelected ? .pink : .gray)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// プレビュー
#Preview {
    HStack {
        FilterChipView(title: "シンプル")
        FilterChipView(title: "かわいい", isSelected: true)
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
