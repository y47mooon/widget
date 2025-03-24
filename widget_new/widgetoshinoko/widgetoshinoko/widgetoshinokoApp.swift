import SwiftUI
import Firebase

@main
struct widgetoshinokoApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // ここでログを出力
                    print("ContentView appeared")
                    print("アプリが正常に起動しました")
                }
        }
    }
}
