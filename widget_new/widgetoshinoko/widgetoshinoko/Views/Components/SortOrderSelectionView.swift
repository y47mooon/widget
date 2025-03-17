import SwiftUI

struct SortOrderSelectionView: View {
    @Binding var selectedOrder: SortOrder
    @Binding var isPresented: Bool
    @State private var temporarySelection: SortOrder
    
    init(selectedOrder: Binding<SortOrder>, isPresented: Binding<Bool>) {
        _selectedOrder = selectedOrder
        _isPresented = isPresented
        _temporarySelection = State(initialValue: selectedOrder.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("フィルター:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Text("表示順")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                ForEach(SortOrder.allCases, id: \.self) { order in
                    OrderButton(
                        title: order.rawValue,
                        isSelected: temporarySelection == order,
                        action: { temporarySelection = order }
                    )
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 16) {
                Button(action: reset) {
                    Text("リセット")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: apply) {
                    Text("決定")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    private func reset() {
        temporarySelection = .popular
    }
    
    private func apply() {
        selectedOrder = temporarySelection
        isPresented = false
    }
}

private struct OrderButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
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
