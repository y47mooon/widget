import SwiftUI
import GaudiyWidgetShared

// 完全に独自のViewを作成
struct ErrorAlertView<Content: View>: View {
    let content: Content
    let error: GaudiyWidgetShared.WidgetError?
    let onDismiss: () -> Void
    
    @State private var showAlert = false
    
    init(error: GaudiyWidgetShared.WidgetError?, onDismiss: @escaping () -> Void = {}, @ViewBuilder content: () -> Content) {
        self.error = error
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    var body: some View {
        content
            .onAppear {
                showAlert = error != nil
            }
            .alert("エラー", isPresented: $showAlert) {
                Button("OK", action: onDismiss)
            } message: {
                Text(error?.errorDescription ?? "エラーが発生しました")
            }
    }
}

// 使いやすくするための拡張
extension View {
    func withErrorAlert(error: GaudiyWidgetShared.WidgetError?, onDismiss: @escaping () -> Void = {}) -> some View {
        ErrorAlertView(error: error, onDismiss: onDismiss) {
            self
        }
    }
}
