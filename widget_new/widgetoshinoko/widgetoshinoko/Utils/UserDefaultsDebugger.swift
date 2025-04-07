import Foundation
import GaudiyWidgetShared

class UserDefaultsDebugger {
    static func printSavedWidgets() {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "savedWidgets") {
            print("標準UserDefaultsに'savedWidgets'が見つかりました")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("標準UserDefaultsのJSONパースエラー: \(error)")
            }
        } else {
            print("標準UserDefaultsに'savedWidgets'が見つかりません")
        }
        
        // App GroupのUserDefaults
        if let groupDefaults = UserDefaults(suiteName: "group.gaudiy.widgetoshinoko") {
            if let groupData = groupDefaults.data(forKey: "savedWidgets") {
                print("グループUserDefaultsに'savedWidgets'が見つかりました")
                do {
                    let json = try JSONSerialization.jsonObject(with: groupData, options: [])
                    print(json)
                } catch {
                    print("グループUserDefaultsのJSONパースエラー: \(error)")
                }
            } else {
                print("グループUserDefaultsに'savedWidgets'が見つかりません")
            }
            
            // 時計プリセットの確認
            if let presetData = groupDefaults.data(forKey: "clock_presets") {
                print("グループUserDefaultsに'clock_presets'が見つかりました")
                do {
                    let decoder = JSONDecoder()
                    let presets = try decoder.decode([ClockPreset].self, from: presetData)
                    print("\n=== 保存されている時計プリセット ===")
                    for preset in presets {
                        print("タイトル: \(preset.title)")
                        print("スタイル: \(preset.style)")
                        print("サイズ: \(preset.size)")
                        print("カテゴリ: \(preset.category)")
                        print("------------------------")
                    }
                } catch {
                    print("clock_presetsのデコードエラー: \(error)")
                }
            } else {
                print("グループUserDefaultsに'clock_presets'が見つかりません")
            }
        }
        
        // すべてのキーを表示
        print("\n--- 標準UserDefaultsのすべてのキー ---")
        for key in userDefaults.dictionaryRepresentation().keys {
            print(key)
        }
        
        if let groupDefaults = UserDefaults(suiteName: "group.gaudiy.widgetoshinoko") {
            print("\n--- グループUserDefaultsのすべてのキー ---")
            for key in groupDefaults.dictionaryRepresentation().keys {
                print(key)
            }
        }
    }
} 