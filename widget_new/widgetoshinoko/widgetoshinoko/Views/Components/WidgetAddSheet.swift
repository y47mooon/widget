import SwiftUI

struct WidgetAddSheet<T>: View {
    let preset: T
    let onAdd: () -> Void
    
    init(preset: T, onAdd: @escaping () -> Void) {
        self.preset = preset
        self.onAdd = onAdd
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ウィジェットを追加")
                .font(.headline)
            
            Text("ウィジェットをホーム画面に追加しますか？")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // プレセットの情報表示
            if let clockPreset = preset as? ClockPreset {
                Text(clockPreset.category.rawValue)
                    .font(.subheadline)
            }
            
            Button("追加する") {
                onAdd()
            }
            .buttonStyle(.borderedProminent)
            
            Button("キャンセル", role: .cancel) {
                // シートを閉じる処理は呼び出し元で処理
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: 300)
    }
}
