import SwiftUI

struct StyleSelectionView: View {
    @State private var selectedStyle = 0
    let styles = ["スタンダード", "ミニマル", "ファンシー", "カレンダー"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("スタイル")
                .font(.headline)
            
            Picker("スタイル", selection: $selectedStyle) {
                ForEach(0..<styles.count) { index in
                    Text(styles[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

#Preview {
    StyleSelectionView()
        .padding()
}
