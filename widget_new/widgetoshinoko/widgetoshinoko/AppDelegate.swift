//
//  AppDelegate.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/27.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("\n\n===================================")
        print("📱 アプリケーション起動 📱")
        print("===================================\n")
        
        // GoogleService-Info.plistの確認
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            print("✅ GoogleService-Info.plist 見つかりました")
        } else {
            print("❌ GoogleService-Info.plist が見つかりません！")
        }
        
        // Firebase初期化
        FirebaseApp.configure()
        print("✅ Firebase設定完了")
        
        // Firestoreの設定
        let settings = Firestore.firestore().settings
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        print("✅ Firestore設定完了")
        
        // アナリティクスを設定
        AnalyticsService.shared.setup()
        
        // アプリ起動イベントを送信
        AnalyticsService.shared.logEvent("app_launched", parameters: [
            "timestamp": Date().timeIntervalSince1970,
            "build_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
            "build_number": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        ])
        
        // 標準のアプリ起動イベントも送信
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        print("✅ 標準アプリ起動イベント送信完了")
        
        print("\n===================================")
        print("🚀 初期化処理完了 🚀")
        print("===================================\n")
        return true
    }
    
    // アプリがバックグラウンドから復帰した時のイベント
    func applicationWillEnterForeground(_ application: UIApplication) {
        // バックグラウンドから復帰した時のイベント
        AnalyticsService.shared.logEvent("app_foregrounded", parameters: nil)
    }
    
    // アプリがバックグラウンドに移行した時のイベント
    func applicationDidEnterBackground(_ application: UIApplication) {
        // バックグラウンドに移行した時のイベント
        AnalyticsService.shared.logEvent("app_backgrounded", parameters: nil)
    }
}
