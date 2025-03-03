import SwiftUI

struct WidgetCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var widgetService = WidgetDataService.shared
    @State private var customWidget = CustomWidgetConfig.defaultConfig
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    StyleSelectionView()
                        .padding(.top)
                    
                    ColorSelectionView()
                    
                    ImageSelectionView()
                    
                    CustomizationOptionsView()
                }
                .padding()
            }
            .navigationTitle("ウィジェット作成")
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
        }
    }
    
    private var cancelButton: some View {
        Button("キャンセル") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("保存") {
            saveWidget()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func saveWidget() {
        var data = widgetService.loadWidgetData()
        data.customWidgets.append(customWidget)
        widgetService.saveWidgetData(data)
    }
}

#Preview {
    WidgetCreationView()
}
