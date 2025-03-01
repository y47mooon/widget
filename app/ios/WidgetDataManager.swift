//
//  WidgetDataManager.swift
//  TempApp
//
//  Created by ゆぅ on 2025/03/01.
//

import Foundation
import React

@objc(WidgetDataManager)
class WidgetDataManager: NSObject {
  
  // App Groupの識別子
  let groupIdentifier = "group.com.gaudy.widget"
  
  @objc
  func setWidgetData(_ data: NSDictionary, 
                     resolver resolve: @escaping RCTPromiseResolveBlock,
                     rejecter reject: @escaping RCTPromiseRejectBlock) {
    guard let userDefaults = UserDefaults(suiteName: groupIdentifier) else {
      reject("ERROR", "Failed to access App Group", nil)
      return
    }
    
    // データを保存
    if let isDarkMode = data["isDarkMode"] as? Bool {
      userDefaults.set(isDarkMode, forKey: "isDarkMode")
    }
    if let isNotificationEnabled = data["isNotificationEnabled"] as? Bool {
      userDefaults.set(isNotificationEnabled, forKey: "isNotificationEnabled")
    }
    
    userDefaults.synchronize()
    resolve(true)
  }
  
  @objc
  func getWidgetData(_ resolve: @escaping RCTPromiseResolveBlock,
                     rejecter reject: @escaping RCTPromiseRejectBlock) {
    guard let userDefaults = UserDefaults(suiteName: groupIdentifier) else {
      reject("ERROR", "Failed to access App Group", nil)
      return
    }
    
    // データを取得
    let data: [String: Any] = [
      "isDarkMode": userDefaults.bool(forKey: "isDarkMode"),
      "isNotificationEnabled": userDefaults.bool(forKey: "isNotificationEnabled")
    ]
    
    resolve(data)
  }
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }
}
