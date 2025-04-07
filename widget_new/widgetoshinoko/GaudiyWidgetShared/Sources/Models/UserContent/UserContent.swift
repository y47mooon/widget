public struct UserContent: Codable {
    public let userId: String
    public let contentId: String
    // 他のプロパティも同様にpublicに
    
    public init(userId: String, contentId: String) {
        self.userId = userId
        self.contentId = contentId
    }
}
