import SwiftUI

struct SortOrderSelectionView: View {
    @Binding var selectedOrder: SortOrder
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            ForEach(SortOrder.allCases, id: \.self) { order in
                Button(action: {
                    selectedOrder = order
                    isPresented = false
                }) {
                    HStack {
                        Text(order.displayName)
                        Spacer()
                        if order == selectedOrder {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SortOrderSelectionView(
        selectedOrder: .constant(.popular),
        isPresented: .constant(true)
    )
    .padding()
}
