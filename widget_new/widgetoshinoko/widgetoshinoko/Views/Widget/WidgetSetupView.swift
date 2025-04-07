import SwiftUI
import GaudiyWidgetShared

struct WidgetSetupView: View {
    private let widgetPreset: WidgetPreset?
    private let clockPreset: ClockPreset?
    private let onComplete: (() -> Void)?
    @State private var selectedSize: WidgetSize
    @State private var currentIndex: Int = 0
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var widgetManager = WidgetManager.shared
    
    // WidgetPreset用の初期化
    init(preset: WidgetPreset, onComplete: (() -> Void)? = nil) {
        self.widgetPreset = preset
        self.clockPreset = nil
        self.onComplete = onComplete
        self._selectedSize = State(initialValue: preset.size)
    }
    
    // ClockPreset用の初期化
    init(preset: ClockPreset, onComplete: (() -> Void)? = nil) {
        self.widgetPreset = nil
        self.clockPreset = preset
        self.onComplete = onComplete
        self._selectedSize = State(initialValue: preset.size)
    }
    
    var body: some View {
        // 大きな式を分割する
        contentView
    }
    
    // 本体のコンテンツを別のコンピューテッドプロパティに分割
    private var contentView: some View {
        VStack(spacing: 20) {
            // ウィジェットプレビュー（サイズ選択なし）
            previewTabView
            
            // 設定ボタン
            addButton
            
            // 下部の説明テキスト
            Text("ホーム画面に戻り、画面を長押しして「+」をタップし、Widgetoshinokoを選んでください。")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitle("ウィジェットのプレビュー", displayMode: .inline)
        .alert("エラー", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .alert("設定完了", isPresented: $showSuccess) {
            Button("OK") { 
                presentationMode.wrappedValue.dismiss()
                onComplete?()
            }
        } message: {
            Text("ウィジェットが設定されました。ホーム画面でウィジェットを追加してください。")
        }
    }
    
    // ウィジェットプレビュー
    private var previewTabView: some View {
        VStack {
            Text("保存済みのウィジェット")
                .font(.headline)
                .padding(.top)
            
            TabView(selection: $currentIndex) {
                ForEach(0..<widgetManager.getWidgetCount(for: selectedSize), id: \.self) { index in
                    if let widget = widgetManager.getWidget(at: index, size: selectedSize) {
                        VStack {
                            Text("#\(index + 1) \(selectedSize.displayName)ウィジェット")
                                .font(.caption)
                            
                            SavedWidgetItemView(widget: widget)
                                .frame(width: 200, height: 200)
                                .padding()
                        }
                        .tag(index)
                    }
                }
                
                // 新規ウィジェット追加枠
                VStack {
                    Text("新規ウィジェット")
                        .font(.caption)
                    
                    if let widgetPreset = widgetPreset {
                        WidgetPresetPreviewView(preset: widgetPreset)
                            .frame(width: 200, height: 200)
                            .padding()
                    } else if let clockPreset = clockPreset {
                        // ClockPresetをWidgetPresetに変換してプレビュー
                        let convertedPreset = WidgetPreset(
                            id: clockPreset.id,
                            title: clockPreset.title,
                            description: clockPreset.description,
                            type: clockPreset.style == .analog ? .analogClock : .digitalClock,
                            size: clockPreset.size,
                            style: clockPreset.style.rawValue,
                            imageUrl: clockPreset.imageUrl ?? "",
                            backgroundColor: nil,
                            requiresPurchase: false,
                            isPurchased: true,
                            configuration: [
                                "style": clockPreset.style.rawValue,
                                "showSeconds": String(clockPreset.showSeconds),
                                "textColor": clockPreset.textColor ?? "#000000",
                                "fontSize": String(clockPreset.fontSize ?? 16)
                            ]
                        )
                        WidgetPresetPreviewView(preset: convertedPreset)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                }
                .tag(widgetManager.getWidgetCount(for: selectedSize))
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 280)
            
            // ウィジェット数の表示
            Text("残り枠: \(widgetManager.remainingSlots(for: selectedSize))")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // 追加ボタン
    private var addButton: some View {
        Button {
            addWidget()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                Text("ウィジェットを追加")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
    
    private func addWidget() {
        // どちらの型のプリセットかによって処理を分ける
        if let widgetPreset = widgetPreset {
            addWidgetPreset(widgetPreset)
        } else if let clockPreset = clockPreset {
            addClockPreset(clockPreset)
        }
    }
    
    private func addWidgetPreset(_ preset: WidgetPreset) {
        // SavedWidgetの構造に合わせて修正
        let widget = SavedWidget(
            id: UUID(),
            presetId: preset.id.uuidString,
            size: selectedSize,
            type: preset.type,
            configuration: GaudiyWidgetShared.WidgetConfiguration(
                textColor: preset.configuration["textColor"] as? String,
                fontSize: preset.configuration["fontSize"] as? Double,
                showSeconds: preset.configuration["showSeconds"] as? Bool
            )
        )
        
        saveWidget(widget)
    }
    
    private func addClockPreset(_ preset: ClockPreset) {
        // ClockPresetからSavedWidgetを生成
        let widget = SavedWidget(
            id: UUID(),
            presetId: preset.id.uuidString,
            size: selectedSize,
            type: preset.style == .analog ? .analogClock : .digitalClock,
            configuration: GaudiyWidgetShared.WidgetConfiguration(
                textColor: preset.textColor,
                fontSize: preset.fontSize,
                showSeconds: preset.showSeconds
            )
        )
        
        saveWidget(widget)
    }
    
    private func saveWidget(_ widget: SavedWidget) {
        do {
            try widgetManager.saveWidget(widget)
            showSuccess = true
        } catch let error as WidgetError {
            errorMessage = error.localizedDescription
            showError = true
        } catch {
            errorMessage = "不明なエラーが発生しました"
            showError = true
        }
    }
}

// 時計プレビュー用のビュー
struct ClockWidgetPreviewView: View {
    let preset: ClockPreset
    let size: WidgetSize
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: preset.textColor ?? "#000000").opacity(0.1))
                .cornerRadius(16)
            
            if preset.style == .analog {
                AnalogClockView()
                    .frame(width: getSize(), height: getSize())
            } else {
                DigitalClockView()
                    .frame(width: getSize(), height: getSize() / 2)
            }
        }
        .frame(width: getSize() * 1.2, height: getSize() * 1.2)
    }
    
    private func getSize() -> CGFloat {
        switch size {
        case .small: return 120
        case .medium: return 160
        case .large: return 200
        }
    }
}

// 色のHex文字列からColorに変換する拡張
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
