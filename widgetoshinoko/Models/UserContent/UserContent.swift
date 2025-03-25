import Foundation
import FirebaseFirestoreSwift

struct UserContent: Identifiable, Codable {
    @DocumentID var id: String?
    var uuid = UUID()
    var userId: String
    var contentId: String
    var isDownloaded: Bool
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case userId = "user_id"
        case contentId = "content_id"
        case isDownloaded = "is_downloaded"
        case createdAt = "created_at"
    }
}
