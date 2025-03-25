import Foundation

struct ClockPreset: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var thumbnailImageName: String
    var configuration: ClockConfiguration
    var category: PresetCategory
    var popularity: Int = 0
    var isFavorite: Bool = false
    var isPublic: Bool = true
    var createdBy: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    enum PresetCategory: String, Codable, CaseIterable {
        case simple = "シンプル"
        case modern = "モダン"
        case classic = "クラシック"
        case custom = "カスタム"
    }
}
