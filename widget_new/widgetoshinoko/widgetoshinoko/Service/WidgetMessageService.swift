import Foundation
import WidgetKit

class WidgetMessageService {
    static let shared = WidgetMessageService()
    
    private let userDefaults: UserDefaults?
    private let messageKey = "widget_message"
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.com.gaudiy.widgetoshinoko")
    }
    
    func saveMessage(_ message: String) {
        userDefaults?.set(message, forKey: messageKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getMessage() -> String {
        return userDefaults?.string(forKey: messageKey) ?? ""
    }
}
