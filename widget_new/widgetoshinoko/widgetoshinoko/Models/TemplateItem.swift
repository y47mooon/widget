import Foundation
import GaudiyWidgetShared

// GaudiyWidgetSharedで定義したTemplateBaseを継承
struct TemplateItem: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let imageUrl: String
    let category: TemplateCategory
    let popularity: Int
    let createdAt: Date
    
    // 追加プロパティ
    let images: [String]?
    let widgets: [WidgetPreset]?
    let icons: [IconSet]?
    let hasMovingWallpaper: Bool
    let hasIcons: Bool
    
    // TemplateBaseからの初期化用コンストラクタ
    init(from base: TemplateBase) {
        self.id = base.id
        self.title = base.title
        self.description = base.description
        self.imageUrl = base.imageUrl
        self.category = base.category
        self.popularity = base.popularity
        self.createdAt = base.createdAt
        self.images = base.images
        
        // ウィジェットプリセットの変換（クロージャを使わないように修正）
        if let baseWidgets = base.widgets {
            var widgetPresets: [WidgetPreset] = []
            for widgetId in baseWidgets {
                if let uuid = UUID(uuidString: widgetId) {
                    widgetPresets.append(Self.createDummyWidgetPreset(id: uuid))
                }
            }
            self.widgets = widgetPresets.isEmpty ? nil : widgetPresets
        } else {
            self.widgets = nil
        }
        
        // アイコンセットの変換（クロージャを使わないように修正）
        if let baseIcons = base.icons {
            var iconSets: [IconSet] = []
            for iconId in baseIcons {
                if let uuid = UUID(uuidString: iconId) {
                    iconSets.append(Self.createDummyIconSet(id: uuid))
                }
            }
            self.icons = iconSets.isEmpty ? nil : iconSets
        } else {
            self.icons = nil
        }
        
        self.hasMovingWallpaper = base.hasMovingWallpaper
        self.hasIcons = base.hasIcons
    }
    
    // 通常のコンストラクタ
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        imageUrl: String,
        category: TemplateCategory = .popular,
        popularity: Int = 0,
        createdAt: Date = Date(),
        images: [String]? = nil,
        widgets: [WidgetPreset]? = nil,
        icons: [IconSet]? = nil,
        hasMovingWallpaper: Bool = false,
        hasIcons: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.popularity = popularity
        self.createdAt = createdAt
        self.images = images
        self.widgets = widgets
        self.icons = icons
        self.hasMovingWallpaper = hasMovingWallpaper
        self.hasIcons = hasIcons
    }
    
    // TemplateBaseに変換するメソッド
    func toTemplateBase() -> TemplateBase {
        // ウィジェットプリセットの文字列への変換
        let widgetStrings: [String]? = widgets?.compactMap { widget in
            // ウィジェットプリセットのIDを文字列として使用
            return widget.id.uuidString
        }
        
        // アイコンセットの文字列への変換
        let iconStrings: [String]? = icons?.compactMap { icon in
            // アイコンセットのIDを文字列として使用
            return icon.id.uuidString
        }
        
        return TemplateBase(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl,
            category: category,
            popularity: popularity,
            createdAt: createdAt,
            images: images,
            widgets: widgetStrings,
            icons: iconStrings,
            hasMovingWallpaper: hasMovingWallpaper,
            hasIcons: hasIcons
        )
    }
    
    // プレースホルダー用のダミーWidgetPresetを作成（静的メソッドに変更）
    private static func createDummyWidgetPreset(id: UUID) -> WidgetPreset {
        return WidgetPreset(
            id: id,
            title: "サンプルウィジェット",
            description: "これはサンプルウィジェットです",
            type: .analogClock,
            size: .medium,
            style: "standard",
            imageUrl: "https://example.com/widget.png",
            backgroundColor: "#ffffff",
            requiresPurchase: false,
            isPurchased: true,
            configuration: [:]
        )
    }
    
    // プレースホルダー用のダミーIconSetを作成（静的メソッドに変更）
    private static func createDummyIconSet(id: UUID) -> IconSet {
        return IconSet(
            id: id,
            title: "サンプルアイコン",
            icons: [
                IconSet.Icon(
                    id: UUID(),
                    imageUrl: "https://example.com/icon.png"
                )
            ],
            category: .popular,
            popularity: 0,
            previewUrl: "https://example.com/icon.png"
        )
    }
} 