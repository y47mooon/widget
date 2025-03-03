import SwiftUI

struct ColorSelectionView: View {
    @State private var selectedColor = Color.blue
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("カラー")
                .font(.headline)
            
            ColorPicker("カラー", selection: $selectedColor)
                .labelsHidden()
            
            // プリセットカラー
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([Color.blue, .red, .green, .yellow, .purple, .orange], id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    ColorSelectionView()
        .padding()
}
