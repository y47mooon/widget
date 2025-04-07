import Foundation

public enum ClockStyle: String, Codable, CaseIterable {
    case analog = "analog"
    case digital = "digital"
    
    public var displayName: String {
        switch self {
        case .analog:
            return "アナログ時計"
        case .digital:
            return "デジタル時計"
        }
    }
}
