import SwiftUI
import GaudiyWidgetShared

struct ClockPresetItemView: View {
    let preset: ClockPreset
    @State private var showPreview = false
    @State private var showingSuccessAlert = false
    
    var body: some View {
        Button(action: {
            showPreview = true
        }) {
            VStack(spacing: 8) {
                // プレビュー画像部分
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(12)
                    
                    // スタイルに応じた時計表示
                    if preset.style == .analog {
                        AnalogClockView()
                            .frame(width: 80, height: 80)
                    } else {
                        DigitalClockView()
                            .frame(width: 80, height: 80)
                    }
                }
                
                // タイトル
                Text(preset.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 説明
                Text(preset.description)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showPreview) {
            NavigationView {
                // WidgetPresetPreviewViewを使用してプレビュー画面に変更
                let widgetPreset = convertToWidgetPreset(preset)
                
                WidgetPresetPreviewView(
                    preset: widgetPreset,
                    onComplete: {
                        showPreview = false
                        showingSuccessAlert = true
                    }
                )
            }
        }
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("設定完了"),
                message: Text("ウィジェットの設定が完了しました。ホーム画面に戻り、ウィジェットを追加してください。"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // ClockPresetをWidgetPresetに変換する関数
    private func convertToWidgetPreset(_ clockPreset: ClockPreset) -> WidgetPreset {
        return WidgetPreset(
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
    }
}