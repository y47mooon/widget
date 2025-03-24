import SwiftUI

struct CreateMenuView: View {
    @Binding var selectedType: WidgetCreationType?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            ForEach(WidgetCreationType.allCases, id: \.self) { type in
                Button(action: {
                    selectedType = type
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: type.iconName)
                        Text(type.displayName)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateMenuView(selectedType: .constant(nil))
}