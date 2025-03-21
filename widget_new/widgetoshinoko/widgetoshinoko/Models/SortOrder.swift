import Foundation

enum SortOrder: String, CaseIterable {
    case popular = "人気順"
    case newest = "新着順"
    case oldest = "古い順"
    
    var displayName: String {
        return self.rawValue
    }
}
