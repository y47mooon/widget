import SwiftUI
struct CreateMenuView: View {
    @Binding var isPresented: Bool
    @Binding var selectedCreationType: WidgetCreationType?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("作成する")
                .font(.headline)
                .padding(.vertical)
            
            ForEach(WidgetCreationType.allCases.dropLast(), id: \.self) { type in
                Button(action: {
                    selectedCreationType = type
                    isPresented = false
                }) {
                    Text(type.title)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                Divider()
            }
            
            Button(action: {
                isPresented = false
            }) {
                Text("キャンセル")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .padding()
    }
}