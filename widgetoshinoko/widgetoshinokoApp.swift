import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseAuth

@main
struct widgetoshinokoApp: App {
    init() {
        // Firebase初期化
        do {
            FirebaseApp.configure()
            
            // Firestoreの設定
            let settings = Firestore.firestore().settings
            settings.isPersistenceEnabled = true  // オフラインキャッシュを有効化
            Firestore.firestore().settings = settings
            
            // Authの設定（必要に応じて）
            Auth.auth().languageCode = "ja"  // 認証メールを日本語に設定
            
            // ログイベント
            Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
            print("Firebase初期化完了")
        } catch {
            print("Firebase初期化エラー: \(error.localizedDescription)")
            // 実運用環境では適切なエラー処理（例：クラッシュレポート送信など）
        }
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
