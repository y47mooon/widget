import Foundation // UUID, Dateのために必要

struct IconSet: Identifiable {
    let id: UUID
    let title: String
    let icons: [Icon]
    let category: IconCategory
    let popularity: Int
    let createdAt: Date
    
    struct Icon: Identifiable {
        let id: UUID
        let imageUrl: String
        let targetAppBundleId: String? // 設定対象のアプリのバンドルID
    }
}

enum IconCategory: String, CaseIterable {
    case popular = "人気のアイコンセット"
    case new = "新着"
    case cute = "かわいい"
    case cool = "おしゃれ"
    case white = "白"
    case dark = "ダーク"
}
