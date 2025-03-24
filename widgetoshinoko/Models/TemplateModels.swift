import Foundation

// テンプレートアイテムのモデル
struct TemplateItem: Identifiable {
    let id: UUID
    let imageUrl: String
    let title: String
    let category: TemplateCategory
    // 必要に応じて他のプロパティを追加
}
