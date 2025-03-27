import SwiftUI
import GaudiyWidgetShared

// ここで定義していたCustomWidgetConfigを削除（すでに別ファイルにある）

struct WidgetCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var widgetService = WidgetDataService.shared
    @State private var customWidget = CustomWidgetConfig.defaultConfig
    @State private var selectedStyleIndex = 0
    @State private var selectedColor = Color.black // デフォルト色を黒に変更
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // スタイル選択ビュー
                    VStack(alignment: .leading) {
                        Text("スタイルを選択")
                            .font(.headline)
                        
                        // スタイル選択UI - 列挙型に合わせて変更
                        HStack {
                            ForEach([CustomWidgetConfig.WidgetStyle.standard, 
                                     .minimal, 
                                     .fancy, 
                                     .calendar], id: \.self) { style in
                                StyleButton(
                                    isSelected: customWidget.style == style,
                                    title: style.rawValue
                                ) {
                                    customWidget.style = style
                                    updateWidget()
                                }
                            }
                        }
                    }
                    .padding(.top)
                    
                    // 色選択ビュー
                    VStack(alignment: .leading) {
                        Text("カラーを選択")
                            .font(.headline)
                        
                        // 色選択UI
                        HStack {
                            ForEach([Color.black, Color.blue, Color.red, Color.green, Color.purple], id: \.self) { color in
                                ColorButton(
                                    color: color,
                                    isSelected: selectedColor == color
                                ) {
                                    selectedColor = color
                                    updateWidget()
                                }
                            }
                        }
                    }
                    
                    // その他の設定
                    VStack(alignment: .leading) {
                        Text("その他設定")
                            .font(.headline)
                        
                        Toggle("枠線を表示", isOn: Binding<Bool>(
                            get: { customWidget.showBorder },
                            set: { 
                                customWidget.showBorder = $0
                                updateWidget()
                            }
                        ))
                        
                        HStack {
                            Text("フォントサイズ: \(Int(customWidget.fontSize))")
                            Slider(value: Binding<Double>(
                                get: { customWidget.fontSize },
                                set: { 
                                    customWidget.fontSize = $0
                                    updateWidget()
                                }
                            ), in: 10...24, step: 1)
                        }
                        
                        HStack {
                            Text("不透明度: \(Int(customWidget.opacity * 100))%")
                            Slider(value: Binding<Double>(
                                get: { customWidget.opacity },
                                set: { 
                                    customWidget.opacity = $0
                                    updateWidget()
                                }
                            ), in: 0.2...1.0, step: 0.1)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("ウィジェット作成")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveWidget()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveWidget() {
        // WidgetDataServiceのpublicメソッドを使用
        widgetService.saveCustomWidget(customWidget)
    }
    
    private func updateWidget() {
        // 色の更新
        customWidget.color = colorToHex(selectedColor)
        
        // 画像があれば更新
        if let image = selectedImage, let imageName = saveImage(image) {
            customWidget.imageName = imageName
        }
    }
    
    private func saveImage(_ image: UIImage) -> String? {
        // 画像保存ロジック（簡略化）
        return "saved_image_\(UUID().uuidString)"
    }
    
    private func colorToHex(_ color: Color) -> String {
        // 簡易的な色をHex変換
        if color == Color.black { return "#000000" }
        if color == Color.blue { return "#0000FF" }
        if color == Color.red { return "#FF0000" }
        if color == Color.green { return "#00FF00" }
        if color == Color.purple { return "#800080" }
        return "#000000" // デフォルト
    }
}

// スタイルボタンコンポーネント
struct StyleButton: View {
    var isSelected: Bool
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

// 色選択ボタン
struct ColorButton: View {
    var color: Color
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
                )
                .shadow(color: isSelected ? Color.black.opacity(0.3) : Color.clear, radius: 3)
        }
    }
}

// プレビュー
struct WidgetCreationView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetCreationView()
    }
}