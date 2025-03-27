//
//  ClockPreset.swift
//  GaudiyWidgetShared
//
//  Created by ゆぅ on 2025/03/26.
//

import Foundation

// ClockPreset型の定義
public struct ClockPreset: Identifiable, Codable {
    public var id = UUID()
    public var title: String
    public var description: String
    public var thumbnailImageName: String
    public var configuration: ClockConfiguration
    public var category: PresetCategory
    public var popularity: Int = 0
    public var isFavorite: Bool = false
    public var isPublic: Bool = true
    public var createdBy: String
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    public enum PresetCategory: String, Codable, CaseIterable {
        case simple = "シンプル"
        case modern = "モダン"
        case classic = "クラシック"
        case custom = "カスタム"
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        thumbnailImageName: String,
        configuration: ClockConfiguration,
        category: PresetCategory,
        popularity: Int = 0,
        isFavorite: Bool = false,
        isPublic: Bool = true,
        createdBy: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailImageName = thumbnailImageName
        self.configuration = configuration
        self.category = category
        self.popularity = popularity
        self.isFavorite = isFavorite
        self.isPublic = isPublic
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
