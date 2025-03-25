public enum WidgetSize {
    case small
    case medium
    case large
    
    public var size: CGSize {
        switch self {
        case .small: return CGSize(width: 155, height: 155)
        case .medium: return CGSize(width: 329, height: 155)
        case .large: return CGSize(width: 329, height: 345)
        }
    }
    public var width: CGFloat { size.width }
    public var height: CGFloat { size.height }
}
