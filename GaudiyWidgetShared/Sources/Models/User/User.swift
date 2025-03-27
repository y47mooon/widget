public struct User: Codable {
    public let id: String
    public let name: String
    // 他のプロパティも同様にpublicに
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
