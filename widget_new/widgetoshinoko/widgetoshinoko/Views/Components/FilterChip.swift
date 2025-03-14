import SwiftUI

struct FilterChipView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.pink, lineWidth: 1)
            )
            .foregroundColor(.pink)
    }
}
