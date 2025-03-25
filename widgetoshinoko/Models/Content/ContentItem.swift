import Foundation
import FirebaseFirestoreSwift

struct ContentItem: Identifiable, Codable {
    @DocumentID var id: String?
    var uuid = UUID()
    var contentName: String
    var contentType: String
    var requiredStatus: String
    var url: String
    var createdAt: Date
    var updatedAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case contentName = "content_name"
        case contentType = "content_type"
        case requiredStatus = "required_status"
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
