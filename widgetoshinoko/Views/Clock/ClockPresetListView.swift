import SwiftUI
import GaudiyWidgetShared

struct ClockPresetListView: View {
    @StateObject private var viewModel: ClockPresetsViewModel
    @State private var showingWidgetSheet = false
    @State private var selectedPreset: ClockPreset?
    
    init() {
        _viewModel = StateObject(wrappedValue: ClockPresetsViewModel())
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.presets) { preset in
                    VStack {
                        WidgetSizeView(size: .small)
                            .overlay(
                                ClockWidgetView(size: .small, configuration: preset.configuration)
                            )
                        Text(preset.title)
                            .font(.caption)
                    }
                    .onTapGesture {
                        selectedPreset = preset
                        showingWidgetSheet = true
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingWidgetSheet) {
            if let preset = selectedPreset {
                WidgetAddSheet(preset: preset) {
                    if let data = try? JSONEncoder().encode(preset.configuration) {
                        UserDefaults(suiteName: Constants.appGroupID)?.set(data, forKey: Constants.clockPresetKey)
                    }
                    showingWidgetSheet = false
                }
            }
        }
        .navigationTitle("時計ウィジェット")
        .onAppear {
            Task {
                await viewModel.fetchPresets()
            }
        }
    }
}
