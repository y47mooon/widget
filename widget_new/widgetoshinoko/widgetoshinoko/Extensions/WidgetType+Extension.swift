import Foundation
import GaudiyWidgetShared

extension WidgetType {
    var templateType: WidgetTemplateType {
        switch self {
        case .analogClock:
            return .analogClock
        case .digitalClock:
            return .digitalClock
        case .weather:
            return .weather
        case .calendar:
            return .calendar
        case .photo:
            return .photo
        }
    }
}
