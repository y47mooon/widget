import Foundation

// 言語設定を管理するクラス
class LanguageService {
    static let shared = LanguageService()
    
    private let languageCodeKey = "app_language_code"
    private let userDefaults = UserDefaults.standard
    
    enum AppLanguage: String, CaseIterable {
        case system = "system" // システム設定に従う
        case english = "en"    // 英語
        case japanese = "ja"   // 日本語
        
        var displayName: String {
            switch self {
            case .system:
                return "System".localized
            case .english:
                return "English"
            case .japanese:
                return "日本語"
            }
        }
    }
    
    // 現在設定されている言語コード
    var currentLanguageCode: String {
        if let savedLanguage = userDefaults.string(forKey: languageCodeKey),
           AppLanguage(rawValue: savedLanguage) != nil {
            return savedLanguage
        }
        return AppLanguage.system.rawValue
    }
    
    // 現在の言語設定
    var currentLanguage: AppLanguage {
        if let code = AppLanguage(rawValue: currentLanguageCode) {
            return code
        }
        return .system
    }
    
    // 実際に適用されている言語コード（システム設定の場合はデバイスの言語）
    var effectiveLanguageCode: String {
        if currentLanguage == .system {
            // システム設定の場合はデバイスの言語を取得
            let preferredLanguages = Bundle.main.preferredLocalizations
            if let deviceLanguage = preferredLanguages.first {
                // 対応している言語に変換
                if deviceLanguage.starts(with: "ja") {
                    return AppLanguage.japanese.rawValue
                } else {
                    return AppLanguage.english.rawValue
                }
            }
            return AppLanguage.english.rawValue
        } else {
            return currentLanguageCode
        }
    }
    
    // 言語設定を変更
    func setLanguage(_ language: AppLanguage) {
        userDefaults.set(language.rawValue, forKey: languageCodeKey)
    }
}

// String拡張にlocalized機能を追加
extension String {
    var localized: String {
        let languageCode = LanguageService.shared.effectiveLanguageCode
        
        // 特定の言語用のBundleを取得
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        }
        
        // デフォルトの場合、現在のBundleから取得
        return NSLocalizedString(self, comment: "")
    }
} 