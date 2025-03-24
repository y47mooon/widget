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
