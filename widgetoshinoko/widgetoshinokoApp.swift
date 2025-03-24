import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct widgetoshinokoApp: App {
    init() {
        FirebaseApp.configure()
        // デバッグ用のログを追加
        print("Firebase初期化開始")
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        print("Analyticsイベント送信完了")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("ContentView表示")
                }
        }
    }
}
