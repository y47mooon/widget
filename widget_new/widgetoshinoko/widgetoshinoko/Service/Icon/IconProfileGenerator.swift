import Foundation
import UIKit

/// アイコン設定用のモバイル構成プロファイル生成サービス
class IconProfileGenerator {
    /// シングルトンインスタンス
    static let shared = IconProfileGenerator()
    
    private init() {}
    
    /// モバイル構成プロファイルを生成する
    /// - Parameters:
    ///   - icons: アイコン情報の配列
    /// - Returns: 生成されたモバイル構成プロファイルのデータ
    func generateMobileConfig(icons: [IconConfigItem]) -> Data? {
        // ルート辞書の作成
        var rootDict: [String: Any] = [
            "PayloadContent": createPayloadContent(icons: icons),
            "PayloadDescription": "Widgetoshinokoからのアイコンセットです",
            "PayloadDisplayName": "Widgetoshinoko Icon Set",
            "PayloadIdentifier": "com.widgetoshinoko.iconprofile.\(UUID().uuidString)",
            "PayloadRemovalDisallowed": false,
            "PayloadType": "Configuration",
            "PayloadUUID": UUID().uuidString,
            "PayloadVersion": 1
        ]
        
        // PropertyListのエンコード
        do {
            return try PropertyListSerialization.data(fromPropertyList: rootDict, format: .xml, options: 0)
        } catch {
            print("モバイル構成プロファイルの生成エラー: \(error)")
            return nil
        }
    }
    
    /// ペイロードコンテンツを作成
    private func createPayloadContent(icons: [IconConfigItem]) -> [[String: Any]] {
        return icons.compactMap { item -> [String: Any]? in
            guard let bundleId = item.targetAppBundleId, !bundleId.isEmpty else {
                return nil // バンドルIDがない場合はスキップ
            }
            
            return [
                "FullScreen": false,
                "Icon": loadIconData(from: item.imageUrl),
                "IsRemovable": true,
                "Label": item.title,
                "PayloadDescription": "Webクリップ設定",
                "PayloadDisplayName": item.title,
                "PayloadIdentifier": "com.widgetoshinoko.webclip.\(UUID().uuidString)",
                "PayloadType": "com.apple.webClip.managed",
                "PayloadUUID": UUID().uuidString,
                "PayloadVersion": 1,
                "Precomposed": true,
                "URL": "https://\(bundleId)"
            ]
        }
    }
    
    /// アイコン画像データを読み込む
    private func loadIconData(from urlString: String) -> Data {
        // リモートURLからアイコンデータを読み込む処理
        if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
            return data
        }
        
        // デフォルトアイコンデータを返す
        return UIImage(systemName: "questionmark.app.fill")?.pngData() ?? Data()
    }
    
    /// 構成プロファイルを共有する
    func shareProfile(icons: [IconConfigItem], from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let profileData = generateMobileConfig(icons: icons) else {
            completion(false)
            return
        }
        
        // 一時ファイルを作成
        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("widgetoshinoko_icons.mobileconfig")
        
        do {
            try profileData.write(to: tempFileURL)
            
            // アクティビティビューコントローラーを表示
            let activityVC = UIActivityViewController(activityItems: [tempFileURL], applicationActivities: nil)
            viewController.present(activityVC, animated: true)
            
            // 共有完了時のコールバック
            activityVC.completionWithItemsHandler = { _, success, _, _ in
                completion(success)
            }
        } catch {
            print("プロファイルの保存エラー: \(error)")
            completion(false)
        }
    }
}

/// アイコン設定項目
struct IconConfigItem {
    let id: UUID
    let title: String
    let imageUrl: String
    let targetAppBundleId: String?
    
    init(id: UUID = UUID(), title: String, imageUrl: String, targetAppBundleId: String?) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.targetAppBundleId = targetAppBundleId
    }
    
    /// IconオブジェクトからIconConfigItemを生成
    static func from(icon: IconSet.Icon, title: String) -> IconConfigItem {
        return IconConfigItem(
            id: icon.id,
            title: title,
            imageUrl: icon.imageUrl,
            targetAppBundleId: icon.targetAppBundleId
        )
    }
} 