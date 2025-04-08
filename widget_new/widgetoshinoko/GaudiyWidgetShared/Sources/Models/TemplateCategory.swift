import Foundation

/// CategoryTypeプロトコル定義（widgetokosinokoのContentTypes.swiftと同じ）
public protocol CategoryType {
    var rawValue: String { get }
    static var allCases: [Self] { get }
    var displayName: String { get }
}

/// テンプレートのカテゴリーを定義する列挙型
public enum TemplateCategory: String, CaseIterable, Codable, CategoryType {
    case popular = "template_popular"
    case new = "template_new"
    case recommended = "template_recommended"
    case seasonal = "template_seasonal"
    case simple = "template_simple"
    case minimal = "template_minimal"
    case stylish = "template_stylish"
    
    public var displayName: String {
        switch self {
        case .popular: return "人気"
        case .new: return "新着"
        case .recommended: return "おすすめ"
        case .seasonal: return "季節"
        case .simple: return "シンプル"
        case .minimal: return "ミニマル"
        case .stylish: return "スタイリッシュ"
        }
    }
    
    public var localizedTitle: String {
        return self.rawValue
    }
}

/// テンプレートアイテムの基本情報
public struct TemplateBase: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String?
    public let imageUrl: String
    public let category: TemplateCategory
    public let popularity: Int
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        imageUrl: String,
        category: TemplateCategory = .popular,
        popularity: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.popularity = popularity
        self.createdAt = createdAt
    }
} 