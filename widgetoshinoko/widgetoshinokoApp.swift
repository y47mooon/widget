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
    init() {
        #if canImport(FirebaseCore)
        // Firebase初期化
        do {
            FirebaseApp.configure()
            
            // Firestoreの設定
            let settings = Firestore.firestore().settings
            settings.isPersistenceEnabled = true  // オフラインキャッシュを有効化
            Firestore.firestore().settings = settings
            
            
            // ログイベント
            Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
            print("Firebase初期化完了")
        } catch {
            print("Firebase初期化エラー: \(error.localizedDescription)")
            // 実運用環境では適切なエラー処理（例：クラッシュレポート送信など）
        }
        #endif
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
