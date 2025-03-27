//
//  CustomWidgetConfig.swift
//  GaudiyWidgetShared
//
//  Created by ゆぅ on 2025/03/26.
//

import Foundation
import SwiftUI

public struct CustomWidgetConfig: Identifiable, Codable {
    public var id = UUID()
    public var style: WidgetStyle = .standard
    public var color: String = "#000000"
    public var imageName: String?
    public var fontSize: Double = 14.0
    public var cornerRadius: Double = 12.0
    public var opacity: Double = 1.0
    public var showBorder: Bool = false
    public var borderWidth: Double = 1.0
    
    public enum WidgetStyle: String, Codable {
        case standard = "スタンダード"
        case minimal = "ミニマル"
        case fancy = "ファンシー"
        case calendar = "カレンダー"
    }
    
    public init(id: UUID = UUID(), style: WidgetStyle = .standard, color: String = "#000000",
                imageName: String? = nil, fontSize: Double = 14.0, cornerRadius: Double = 12.0,
                opacity: Double = 1.0, showBorder: Bool = false, borderWidth: Double = 1.0) {
        self.id = id
        self.style = style
        self.color = color
        self.imageName = imageName
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.showBorder = showBorder
        self.borderWidth = borderWidth
    }
    
    public static let defaultConfig = CustomWidgetConfig()
}
