import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseDatabase
// 他の必要なFirebaseモジュール
#endif

@main
struct widgetoshinokoApp: App {
    // AppDelegateを使用
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("ContentView表示")
                    // 画面表示のアナリティクスイベントを送信
                    AnalyticsService.shared.logScreenView("ContentView", screenClass: "ContentView")
                }
        }
    }
}
