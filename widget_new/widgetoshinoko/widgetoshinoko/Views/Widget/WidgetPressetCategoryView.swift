import SwiftUI
import GaudiyWidgetShared

struct WidgetPresetCategoryView: View {
    let widgetType: WidgetType
    @State private var selectedSize: WidgetSize = .small
    @StateObject private var viewModel = WidgetPresetViewModel()
    
    var body: some View {
        VStack {
            // サイズ選択
            Picker("サイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.displayName).tag(size)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // プリセット一覧
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150))
                ], spacing: 16) {
                    ForEach(viewModel.filteredPresets) { preset in
                        NavigationLink(
                            destination: WidgetPresetPreviewView(preset: preset)
                        ) {
                            WidgetPresetItemView(preset: preset)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle(widgetType.displayName)
        .task {
            await viewModel.loadPresets(type: widgetType)
        }
        .onChange(of: selectedSize) { newSize in
            viewModel.filterBySize(newSize)
        }
    }
}
