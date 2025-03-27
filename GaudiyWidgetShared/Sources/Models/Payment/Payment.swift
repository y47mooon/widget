public struct Payment: Codable {
    public let id: UUID
    public let userId: String
    public let amount: Double
    public let date: Date
    
    public init(id: UUID = UUID(), userId: String, amount: Double, date: Date = Date()) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.date = date
    }
}
