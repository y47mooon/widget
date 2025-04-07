import Foundation
import SwiftUI
import GaudiyWidgetShared

public class WidgetPresetService {
    // シングルトン
    public static let shared = WidgetPresetService()
    
    private init() {}
    
    // カテゴリとサイズでプリセットを取得
    public func getPresets(type: WidgetType, size: WidgetSize? = nil) -> [WidgetPreset] {
        var presets = mockPresets.filter { $0.type == type }
        if let size = size {
            presets = presets.filter { $0.size == size }
        }
        return presets
    }
    
    // モックデータ
    private var mockPresets: [WidgetPreset] = [
        // アナログ時計（小）
        WidgetPreset(
            id: UUID(),
            title: "アナログ時計 小",
            description: "クラシックデザインのアナログ時計", 
            type: .analogClock, 
            size: .small, 
            style: "classic",
            imageUrl: "clock_analog_classic_small", 
            backgroundColor: "#FFFFFF", 
            requiresPurchase: false, 
            isPurchased: false,
            configuration: ["hourHandColor": "#000000", "minuteHandColor": "#000000", "textColor": "#000000", "fontSize": 14.0]
        ),
        // アナログ時計（中）
        WidgetPreset(
            id: UUID(),
            title: "アナログ時計 中",
            description: "クラシックデザインのアナログ時計", 
            type: .analogClock, size: .medium, style: "classic",
            imageUrl: "clock_analog_classic_medium", 
            backgroundColor: "#FFFFFF", requiresPurchase: false, isPurchased: false,
            configuration: ["hourHandColor": "#000000", "minuteHandColor": "#000000", "textColor": "#ffffff", "fontSize": 18.0]
        ),
        // アナログ時計（大）
        WidgetPreset(
            id: UUID(),
            title: "アナログ時計 大",
            description: "クラシックデザインのアナログ時計", 
            type: .analogClock, size: .large, style: "classic",
            imageUrl: "clock_analog_classic_large", 
            backgroundColor: "#FFFFFF", requiresPurchase: false, isPurchased: false,
            configuration: ["hourHandColor": "#000000", "minuteHandColor": "#000000", "textColor": "#ffffff", "fontSize": 24.0]
        ),
        // モダンなアナログ時計（小）
        WidgetPreset(
            id: UUID(),
            title: "モダンアナログ時計 小",
            description: "モダンデザインのアナログ時計", 
            type: .analogClock, size: .small, style: "modern",
            imageUrl: "clock_analog_modern_small", 
            backgroundColor: "#000000", requiresPurchase: true, isPurchased: false,
            configuration: ["hourHandColor": "#FFFFFF", "minuteHandColor": "#FF5555", "textColor": "#FFFFFF", "fontSize": 14.0]
        ),
        
        // デジタル時計（小）- 5種類
        WidgetPreset(
            id: UUID(),
            title: "シンプルデジタル時計 小 1",
            description: "シンプルなデジタル時計", 
            type: .digitalClock, size: .small, style: "simple",
            imageUrl: "clock_digital_simple_small_1", 
            backgroundColor: "#FFFFFF", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Helvetica", "textColor": "#000000", "fontSize": 14.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "シンプルデジタル時計 小 2",
            description: "シンプルなデジタル時計", 
            type: .digitalClock, size: .small, style: "simple2",
            imageUrl: "clock_digital_simple_small_2", 
            backgroundColor: "#F0F0F0", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Arial", "textColor": "#333333", "fontSize": 14.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "モダンデジタル時計 小 1",
            description: "モダンなデジタル時計", 
            type: .digitalClock, size: .small, style: "modern",
            imageUrl: "clock_digital_modern_small_1", 
            backgroundColor: "#000000", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "SF Pro", "textColor": "#FFFFFF", "fontSize": 14.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "カラフルデジタル時計 小 1",
            description: "カラフルなデジタル時計", 
            type: .digitalClock, size: .small, style: "colorful",
            imageUrl: "clock_digital_colorful_small_1", 
            backgroundColor: "#FF5555", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Avenir", "textColor": "#FFFFFF", "fontSize": 14.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "ミニマルデジタル時計 小 1",
            description: "ミニマルなデジタル時計", 
            type: .digitalClock, size: .small, style: "minimal",
            imageUrl: "clock_digital_minimal_small_1", 
            backgroundColor: "#EFEFEF", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Futura", "textColor": "#555555", "fontSize": 14.0]
        ),
        
        // デジタル時計（中）- 5種類
        WidgetPreset(
            id: UUID(),
            title: "シンプルデジタル時計 中 1",
            description: "シンプルなデジタル時計", 
            type: .digitalClock, size: .medium, style: "simple",
            imageUrl: "clock_digital_simple_medium_1", 
            backgroundColor: "#FFFFFF", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Helvetica", "textColor": "#000000", "fontSize": 18.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "シンプルデジタル時計 中 2",
            description: "シンプルなデジタル時計", 
            type: .digitalClock, size: .medium, style: "simple2",
            imageUrl: "clock_digital_simple_medium_2", 
            backgroundColor: "#F0F0F0", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Arial", "textColor": "#333333", "fontSize": 18.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "モダンデジタル時計 中 1",
            description: "モダンなデジタル時計", 
            type: .digitalClock, size: .medium, style: "modern",
            imageUrl: "clock_digital_modern_medium_1", 
            backgroundColor: "#000000", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "SF Pro", "textColor": "#FFFFFF", "fontSize": 18.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "カラフルデジタル時計 中 1",
            description: "カラフルなデジタル時計", 
            type: .digitalClock, size: .medium, style: "colorful",
            imageUrl: "clock_digital_colorful_medium_1", 
            backgroundColor: "#FF5555", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Avenir", "textColor": "#FFFFFF", "fontSize": 18.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "ミニマルデジタル時計 中 1",
            description: "ミニマルなデジタル時計", 
            type: .digitalClock, size: .medium, style: "minimal",
            imageUrl: "clock_digital_minimal_medium_1", 
            backgroundColor: "#EFEFEF", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Futura", "textColor": "#555555", "fontSize": 18.0]
        ),
        
        // デジタル時計（大）- 5種類
        WidgetPreset(
            id: UUID(),
            title: "シンプルデジタル時計 大 1",
            description: "シンプルなデジタル時計", 
            type: .digitalClock, size: .large, style: "simple",
            imageUrl: "clock_digital_simple_large_1", 
            backgroundColor: "#FFFFFF", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Helvetica", "textColor": "#000000", "fontSize": 24.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "シンプルデジタル時計 大 2",
            description: "シンプルなデジタル時計", 
            type: .digitalClock, size: .large, style: "simple2",
            imageUrl: "clock_digital_simple_large_2", 
            backgroundColor: "#F0F0F0", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Arial", "textColor": "#333333", "fontSize": 24.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "モダンデジタル時計 大 1",
            description: "モダンなデジタル時計", 
            type: .digitalClock, size: .large, style: "modern",
            imageUrl: "clock_digital_modern_large_1", 
            backgroundColor: "#000000", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "SF Pro", "textColor": "#FFFFFF", "fontSize": 24.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "カラフルデジタル時計 大 1",
            description: "カラフルなデジタル時計", 
            type: .digitalClock, size: .large, style: "colorful",
            imageUrl: "clock_digital_colorful_large_1", 
            backgroundColor: "#FF5555", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Avenir", "textColor": "#FFFFFF", "fontSize": 24.0]
        ),
        WidgetPreset(
            id: UUID(),
            title: "ミニマルデジタル時計 大 1",
            description: "ミニマルなデジタル時計", 
            type: .digitalClock, size: .large, style: "minimal",
            imageUrl: "clock_digital_minimal_large_1", 
            backgroundColor: "#EFEFEF", requiresPurchase: false, isPurchased: false,
            configuration: ["fontName": "Futura", "textColor": "#555555", "fontSize": 24.0]
        )
    ]
    
    public func getPreset(with id: UUID) -> WidgetPreset? {
        // 実際の実装ではデータベースまたはキャッシュから検索
        // サンプルとしてモックデータから検索
        return mockPresets.first { $0.id == id }
    }
}
