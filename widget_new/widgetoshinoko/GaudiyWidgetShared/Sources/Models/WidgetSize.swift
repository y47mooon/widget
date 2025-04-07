import Foundation
import SwiftUI

public enum WidgetSize: String, Codable, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    public var size: CGSize {
        switch self {
        case .small: return CGSize(width: 155, height: 155)
        case .medium: return CGSize(width: 329, height: 155)
        case .large: return CGSize(width: 329, height: 345)
        }
    }
    public var width: CGFloat { size.width }
    public var height: CGFloat { size.height }
    
    public var displayName: String {
        return self.rawValue
    }
    
    var previewScale: CGFloat {
        switch self {
        case .small: return 0.8  // 実際のサイズの80%
        case .medium: return 0.7 // 実際のサイズの70%
        case .large: return 0.6  // 実際のサイズの60%
        }
    }
    
    var dimensions: CGSize {
        switch self {
        case .small: return CGSize(width: 170, height: 170)
        case .medium: return CGSize(width: 364, height: 170)
        case .large: return CGSize(width: 364, height: 382)
        }
    }
}
