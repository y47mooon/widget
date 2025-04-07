import Foundation

public enum WidgetTemplateType: String, Codable {
    case analogClock
    case digitalClock
    case calendar
    case weather
    case photo
}

public enum WidgetType: String, Codable, CaseIterable {
    case analogClock
    case digitalClock
    case calendar
    case weather
    case photo
    
    public var displayName: String {
        switch self {
        case .analogClock: return "アナログ時計"
        case .digitalClock: return "デジタル時計"
        case .calendar: return "カレンダー"
        case .weather: return "天気"
        case .photo: return "写真"
        }
    }
    
    public var widgetCategory: WidgetCategory {
        switch self {
        case .analogClock, .digitalClock:
            return .clock
        case .weather:
            return .weather
        case .calendar:
            return .calendar
        case .photo:
            return .popular
        }
    }
    
    var templateType: WidgetTemplateType {
        switch self {
        case .analogClock: return .analogClock
        case .digitalClock: return .digitalClock
        case .weather: return .weather
        case .calendar: return .calendar
        case .photo: return .photo
        }
    }
}

// WidgetCategoryも同じファイルに定義
public enum WidgetCategory: String, Codable, CaseIterable {
    case clock
    case weather
    case calendar
    case popular
    case photo
    case reminder
    case date
    case anniversary
    case fortune
    case memo
}
