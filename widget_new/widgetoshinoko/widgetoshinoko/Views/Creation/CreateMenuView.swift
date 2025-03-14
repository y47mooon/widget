import SwiftUI

struct CreateMenuView: View {
    @Binding var isPresented: Bool
    @Binding var selectedCreationType: WidgetCreationType?
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(WidgetCreationType.allCases, id: \.self) { type in
                Button(action: {
                    if type == .cancel {
                        isPresented = false
                    } else {
                        selectedCreationType = type
                        isPresented = false
                    }
                }) {
                    Text(type.rawValue)
                        .foregroundColor(type == .cancel ? .gray : .pink)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.2), radius: 4)
                        )
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
