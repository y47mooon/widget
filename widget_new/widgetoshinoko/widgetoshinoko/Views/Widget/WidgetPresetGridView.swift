import Foundation
import SwiftUI
import GaudiyWidgetShared

// 汎用グリッドビュー - どのようなプリセットタイプでも表示可能
struct GenericWidgetPresetGridView<T: Identifiable>: View {
    let presets: [T]
    let columns: [GridItem]
    let viewForItem: (T) -> AnyView
    let onSelectItem: (T) -> Void
    
    init(
        presets: [T], 
        columns: [GridItem] = [GridItem(.adaptive(minimum: 110, maximum: 120))], 
        @ViewBuilder viewForItem: @escaping (T) -> View,
        onSelectItem: @escaping (T) -> Void
    ) {
        self.presets = presets
        self.columns = columns
        self.viewForItem = { AnyView(viewForItem($0)) }
        self.onSelectItem = onSelectItem
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(presets) { preset in
                Button(action: {
                    onSelectItem(preset)
                }) {
                    viewForItem(preset)
                        .frame(height: 160)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
    }
}

// 既存のClockPresetGridViewの代わりに使用する例
struct ClockPresetGridViewWrapper: View {
    let presets: [ClockPreset]
    @Binding var selectedSize: WidgetSize
    @State private var selectedPreset: ClockPreset?
    @State private var hasCompletedSetup = false

    var body: some View {
        VStack(spacing: 16) {
            // サイズ選択セグメント
            Picker("サイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.displayName).tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // 表示するプリセットを取得
            let filteredPresets = presets.filter { $0.size == selectedSize }
            
            // 汎用WidgetPresetGridViewを使用
            GenericWidgetPresetGridView<ClockPreset>(
                presets: filteredPresets,
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                viewForItem: { (preset: ClockPreset) -> View in
                    ClockPresetItemView(preset: preset)
                        .frame(height: getHeightForSize(selectedSize))
                },
                onSelectItem: { (preset: ClockPreset) in
                    selectedPreset = preset
                }
            )
        }
        .sheet(item: $selectedPreset) { preset in
            NavigationView {
                WidgetPresetPreviewView(
                    preset: convertToWidgetPreset(preset, size: selectedSize),
                    onComplete: {
                        selectedPreset = nil
                        hasCompletedSetup = true
                    }
                )
            }
        }
        .alert(isPresented: $hasCompletedSetup) {
            Alert(
                title: Text("設定完了"),
                message: Text("ウィジェットの設定が完了しました。ホーム画面に戻り、ウィジェットを追加してください。"),
                dismissButton: .default(Text("OK"))
            )
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

    private func convertToWidgetPreset(_ clockPreset: ClockPreset, size: WidgetSize) -> WidgetPreset {
        return WidgetPreset(
            id: clockPreset.id,
            title: clockPreset.title,
            description: clockPreset.description, 
            type: clockPreset.style == .analog ? .analogClock : .digitalClock,
            size: size,
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

// 既存のWidgetPresetGridViewを使用
struct WidgetPresetGridView: View {
    @StateObject private var widgetManager = WidgetManager.shared
    let type: WidgetType
    let size: WidgetSize
    @State private var selectedPreset: WidgetPreset?
    @State private var hasCompletedSetup = false
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
            ForEach(widgetManager.getPresets(for: type)) { preset in
                if preset.size == size {
                    Button(action: {
                        selectedPreset = preset
                    }) {
                        WidgetPresetItemView(preset: preset)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .sheet(item: $selectedPreset) { preset in
            NavigationView {
                WidgetPresetPreviewView(
                    preset: preset,
                    onComplete: {
                        selectedPreset = nil
                        hasCompletedSetup = true
                    }
                )
            }
        }
        .alert(isPresented: $hasCompletedSetup) {
            Alert(
                title: Text("設定完了"),
                message: Text("ウィジェットの設定が完了しました。ホーム画面に戻り、ウィジェットを追加してください。"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
