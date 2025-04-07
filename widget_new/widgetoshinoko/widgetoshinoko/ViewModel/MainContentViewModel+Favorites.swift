import Foundation
import SwiftUI
import GaudiyWidgetShared

extension MainContentViewModel {
    // ウィジェットアイテムのお気に入り状態を切り替え
    func toggleFavorite(widgetId: UUID) {
        if let index = widgetItems.firstIndex(where: { $0.id == widgetId }) {
            widgetItems[index].isFavorite.toggle()
            
            // Firebaseなどで同期処理が必要な場合はここで実装
            
            // 分析のためにイベントを記録
            AnalyticsService.shared.logEvent("widget_favorite_toggled", parameters: [
                "widget_id": widgetId.uuidString,
                "is_favorite": widgetItems[index].isFavorite
            ])
        }
    }
    
    // コンテンツアイテムのお気に入り状態を切り替え
    func toggleFavorite(contentId: UUID, contentType: GaudiyContentType) {
        switch contentType {
        case .template:
            if let index = templateItems.firstIndex(where: { $0.id == contentId }) {
                templateItems[index].isFavorite.toggle()
            }
        case .lockScreen:
            if let index = lockScreenItems.firstIndex(where: { $0.id == contentId }) {
                lockScreenItems[index].isFavorite.toggle()
            }
        case .wallpaper:
            if let index = wallpaperItems.firstIndex(where: { $0.id == contentId }) {
                wallpaperItems[index].isFavorite.toggle()
            }
        case .movingWallpaper:
            if let index = movingWallpaperItems.firstIndex(where: { $0.id == contentId }) {
                movingWallpaperItems[index].isFavorite.toggle()
            }
        default:
            break
        }
        
        // 分析のためにイベントを記録
        AnalyticsService.shared.logEvent("content_favorite_toggled", parameters: [
            "content_id": contentId.uuidString,
            "content_type": contentType.rawValue
        ])
    }
}
