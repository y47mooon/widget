import Foundation

/// ウィジェットのテンプレートタイプを表す列挙型
/// - Note: `.clock`は時計カテゴリ全般を表し、`.analogClock`と`.digitalClock`の両方を含む
public enum WidgetTemplateType: String, Codable, CaseIterable {
    case analogClock
    case digitalClock
    case calendar
    case weather
    case photo
    case clock
    
    /// 表示用の名前を取得
    public var displayName: String {
        switch self {
        case .analogClock: return "アナログ時計"
        case .digitalClock: return "デジタル時計"
        case .calendar: return "カレンダー"
        case .weather: return "天気"
        case .photo: return "写真"
        case .clock: return "時計"
        }
    }
}

/// ウィジェットの具体的なタイプを表す列挙型
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
    
    public var templateType: WidgetTemplateType {
        switch self {
        case .analogClock: return .analogClock
        case .digitalClock: return .digitalClock
        case .weather: return .weather
        case .calendar: return .calendar
        case .photo: return .photo
        }
    }
    
    /// 指定されたテンプレートタイプに基づいてウィジェットタイプを取得
    /// - Parameter templateType: ウィジェットのテンプレートタイプ
    /// - Returns: 対応するウィジェットタイプの配列
    public static func getTypes(for templateType: WidgetTemplateType) -> [WidgetType] {
        switch templateType {
        case .analogClock:
            return [.analogClock]
        case .digitalClock:
            return [.digitalClock]
        case .calendar:
            return [.calendar]
        case .weather:
            return [.weather]
        case .photo:
            return [.photo]
        case .clock:
            return [.analogClock, .digitalClock]
        }
    }
}

/// ウィジェットのカテゴリを表す列挙型
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
