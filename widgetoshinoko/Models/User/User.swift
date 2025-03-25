import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var externalUserId: String
    var email: String
    var membershipStatus: String
    var accessToken: String?
    var refreshToken: String?
    var tokenExpireTime: Date?
    var createdAt: Date
    var updatedAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case externalUserId = "external_user_id"
        case email
        case membershipStatus = "membership_status"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenExpireTime = "token_expire_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
