public struct ClockConfiguration: Codable {
    public var style: ClockStyle
    public var showSeconds: Bool
    public var textColor: String
    public var fontSize: Double
    
    public init(
        style: ClockStyle = .digital,
        showSeconds: Bool = false,
        textColor: String = "#000000",
        fontSize: Double = SharedConstants.Layout.defaultFontSize
    ) {
        self.style = style
        self.showSeconds = showSeconds
        self.textColor = textColor
        self.fontSize = fontSize
    }
}
