import Foundation
import SwiftUI
import GaudiyWidgetShared

/// カレンダーウィジェットのリストを表示するビュー
/// - Note: 実際には任意のウィジェットテンプレートタイプに対応するプリセットを表示できます
struct CalendarWidgetListView: View {
    let templateType: WidgetTemplateType
    @State private var selectedSize: WidgetSize = .small
    @StateObject private var viewModel = WidgetPresetViewModel()
    
    var body: some View {
        VStack {
            // サイズ選択セグメント（プリセット用）
            Picker("サイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.displayName).tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // プリセット一覧
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150))
                ], spacing: 16) {
                    ForEach(viewModel.presets) { preset in
                        WidgetPresetItemView(preset: preset)
                            .frame(height: 150)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(templateType.displayName)
        .task {
            await viewModel.loadPresets(templateType: templateType, size: selectedSize)
        }
        .onChange(of: selectedSize) { newSize in
            Task {
                await viewModel.loadPresets(templateType: templateType, size: newSize)
            }
        }
    }
}

/// 任意のウィジェットタイプのプリセットリストを表示するための汎用ビュー
/// このビューは後でCalendarWidgetListViewを置き換える可能性があります
struct WidgetPresetListView: View {
    let templateType: WidgetTemplateType
    @State private var selectedSize: WidgetSize = .small
    @StateObject private var viewModel = WidgetPresetViewModel()
    
    var body: some View {
        CalendarWidgetListView(templateType: templateType)
    }
}

#Preview {
    NavigationView {
        CalendarWidgetListView(templateType: .calendar)
    }
}

#Preview("アナログ時計") {
    NavigationView {
        CalendarWidgetListView(templateType: .analogClock)
    }
}
