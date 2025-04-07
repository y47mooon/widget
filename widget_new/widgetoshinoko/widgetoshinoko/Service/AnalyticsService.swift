//
//  AnalyticsService.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/27.
//

import Foundation
import FirebaseAnalytics
import GaudiyWidgetShared

class AnalyticsService {
    static let shared = AnalyticsService()
    
    private let userDefaults = UserDefaults(suiteName: SharedConstants.UserDefaults.appGroupID)
    private let lastEventKey = "last_analytics_event"
    private let lastEventNameKey = "last_event_name"
    
    func setup() {
        // デバッグモードを有効にする
        Analytics.setAnalyticsCollectionEnabled(true)
        
        print("\n===================================")
        print("📊 Analytics設定完了 📊")
        print("===================================\n")
    }
    
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        print("\n===================================")
        print("📊 Analyticsイベント送信: \(name)")
        
        if let params = parameters {
            for (key, value) in params {
                print("  → \(key): \(value)")
            }
        }
        
        Analytics.logEvent(name, parameters: parameters)
        
        // App Groupを使ってウィジェットとデータを共有
        userDefaults?.set(Date(), forKey: lastEventKey)
        userDefaults?.set(name, forKey: lastEventNameKey)
        
        print("===================================\n")
    }
    
    func logScreenView(_ screenName: String, screenClass: String) {
        print("\n===================================")
        print("📱 画面表示: \(screenName)")
        print("===================================\n")
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
    }
}
