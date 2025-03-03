import SwiftUI

struct CustomizationOptionsView: View {
    @State private var showBorder = false
    @State private var borderWidth: Double = 1.0
    @State private var cornerRadius: Double = 12.0
    @State private var opacity: Double = 1.0
    @State private var fontSize: Double = 14.0
    @State private var selectedFont = "System"
    
    let fonts = ["System", "Helvetica Neue", "Arial", "Times New Roman"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("詳細設定")
                .font(.headline)
            
            // 枠線の設定
            VStack(alignment: .leading, spacing: 8) {
                Toggle("枠線を表示", isOn: $showBorder)
                
                if showBorder {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("枠線の太さ: \(String(format: "%.1f", borderWidth))")
                        Slider(value: $borderWidth, in: 0.5...5)
                    }
                }
            }
            
            // 角丸の設定
            VStack(alignment: .leading, spacing: 4) {
                Text("角の丸み: \(Int(cornerRadius))")
                Slider(value: $cornerRadius, in: 0...30)
            }
            
            // 透明度の設定
            VStack(alignment: .leading, spacing: 4) {
                Text("透明度: \(Int(opacity * 100))%")
                Slider(value: $opacity, in: 0...1)
            }
            
            // フォント設定
            VStack(alignment: .leading, spacing: 8) {
                Text("フォント設定")
                    .font(.subheadline)
                
                Picker("フォント", selection: $selectedFont) {
                    ForEach(fonts, id: \.self) { font in
                        Text(font).tag(font)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("フォントサイズ: \(Int(fontSize))")
                    Slider(value: $fontSize, in: 10...30)
                }
            }
        }
    }
}

#Preview {
    CustomizationOptionsView()
        .padding()
}
