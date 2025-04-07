import Foundation

enum SortOrder: String, CaseIterable {
    case popular = "popular"
    case newest = "newest"
    case favorite = "favorite"
    
    var displayName: String {
        switch self {
        case .popular:
            return "人気順"
        case .newest:
            return "新着順"
        case .favorite:
            return "お気に入り順"
        }
    }
}
