import Foundation

public enum ClockStyle: String, Codable {
    case digital
    case analog
    case minimal
    
    public var localized: String {
        switch self {
        case .digital: return "デジタル表示"
        case .analog: return "アナログ表示"
        case .minimal: return "ミニマル表示"
        }
    }
}
