import Foundation

public struct ContentConfiguration: Codable, Hashable {
    public var style: String
    public var editableFields: [String]
    
    public init(style: String, editableFields: [String] = []) {
        self.style = style
        self.editableFields = editableFields
    }
}

public struct Content: Identifiable, Codable {
    public var id: String
    public var description: String
    public var category: String
    public var isPublic: Bool
    public var isFavorite: Bool
    public var popularity: Int
    public var status: String
    public var displayOrder: Int
    public var tags: [String]
    public var thumbnailImageName: String
    public var previewImageUrl: String
    public var configuration: ContentConfiguration
    public var createdAt: Date
    public var updatedAt: Date
    public var createdBy: String
    public var updatedBy: String
    
    public init(id: String = UUID().uuidString,
                description: String,
                category: String,
                isPublic: Bool = true,
                isFavorite: Bool = false,
                popularity: Int = 0,
                status: String = "active",
                displayOrder: Int = 0,
                tags: [String] = [],
                thumbnailImageName: String,
                previewImageUrl: String,
                configuration: ContentConfiguration,
                createdAt: Date = Date(),
                updatedAt: Date = Date(),
                createdBy: String,
                updatedBy: String) {
        self.id = id
        self.description = description
        self.category = category
        self.isPublic = isPublic
        self.isFavorite = isFavorite
        self.popularity = popularity
        self.status = status
        self.displayOrder = displayOrder
        self.tags = tags
        self.thumbnailImageName = thumbnailImageName
        self.previewImageUrl = previewImageUrl
        self.configuration = configuration
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.createdBy = createdBy
        self.updatedBy = updatedBy
    }
}
