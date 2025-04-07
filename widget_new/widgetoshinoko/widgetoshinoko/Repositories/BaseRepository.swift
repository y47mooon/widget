import Foundation
import WidgetKit
import GaudiyWidgetShared

protocol DataSyncable {
    func syncToWidgetStorage<T: Encodable>(_ data: T, forKey key: String)
}

class BaseRepository: DataSyncable {
    let userDefaults = UserDefaults(suiteName: SharedConstants.UserDefaults.appGroupID)
    
    func syncToWidgetStorage<T: Encodable>(_ data: T, forKey key: String) {
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("エンコードエラー: \(T.self)")
            return
        }
        userDefaults?.set(encoded, forKey: key)
        
        #if os(iOS)
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        #endif
    }
}
