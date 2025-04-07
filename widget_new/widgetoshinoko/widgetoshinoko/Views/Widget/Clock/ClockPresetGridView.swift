import SwiftUI
import GaudiyWidgetShared

struct ClockPresetGridView: View {
    // 表示するプリセット
    let presets: [WidgetPreset]
    // 選択されたサイズ
    @Binding var selectedSize: WidgetSize
    // ナビゲーション用
    @State private var selectedPreset: WidgetPreset?
    
    var body: some View {
        VStack(spacing: 16) {
            // サイズ選択セグメント
            Picker("サイズ", selection: $selectedSize) {
                Text("Small").tag(WidgetSize.small)
                Text("Medium").tag(WidgetSize.medium)
                Text("Large").tag(WidgetSize.large)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // 汎用ウィジェットグリッドビューを使用
            WidgetPresetGridView(
                type: .analogClock,
                size: selectedSize
            )
        }
        .sheet(item: $selectedPreset) { preset in
            WidgetPresetDetailView(preset: preset)
        }
    }
    
    // サイズに応じた高さを返す
    private func getHeightForSize(_ size: WidgetSize) -> CGFloat {
        switch size {
        case .small: return 120
        case .medium: return 120
        case .large: return 150
        default: return 120
        }
    }
}
