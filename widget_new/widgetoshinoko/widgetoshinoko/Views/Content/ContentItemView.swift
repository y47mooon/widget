import SwiftUI
import GaudiyWidgetShared
import Foundation

// コンテンツアイテムビュー
struct ContentItemView<Category: CategoryType>: View {
    let item: ContentItem<Category>
    let contentType: GaudiyContentType
    let index: Int
    let isInList: Bool
    let size: WidgetSize
    @State private var showPreview = false
    @State private var hasCompletedSetup = false
    
    init(item: ContentItem<Category>, contentType: GaudiyContentType, index: Int, isInList: Bool = false, size: WidgetSize = .small) {
        self.item = item
        self.contentType = contentType
        self.index = index
        self.isInList = isInList
        self.size = size
    }
    
    var body: some View {
        Button(action: {
            showPreview = true
        }) {
            let context: DisplayContext = {
                switch contentType {
                case .template: return .template
                case .icon: return .icon
                case .widget: return .widget
                case .lockScreen: return .home
                case .wallpaper: return .home
                case .movingWallpaper: return .home
                }
            }()
            
            RoundedRectangle(cornerRadius: DesignConstants.Layout.cornerRadius)
                .fill(DesignConstants.Colors.itemBackground)
                .contextFrame(for: context, isInList: isInList)
                .widgetTitleOverlay(item.title)
        }
        .sheet(isPresented: $showPreview) {
            NavigationView {
                if contentType == .wallpaper || contentType == .lockScreen {
                    // 壁紙かロック画面の場合
                    WallpaperPreviewView(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        type: contentType == .wallpaper ? .wallpaper : .lockScreen,
                        contentId: item.id
                    )
                } else if contentType == .widget {
                    // ウィジェットの場合
                    if let preset = item as? WidgetPreset {
                        WidgetPresetPreviewView(
                            preset: preset,
                            onComplete: {
                                hasCompletedSetup = true
                                showPreview = false
                            }
                        )
                    } else {
                        // アイテムからWidgetPresetを作成してプレビュー表示
                        let widgetPreset = WidgetPreset(
                            id: item.id,
                            title: item.title,
                            description: item.description ?? "",
                            type: .calendar,  // 適切なタイプを指定
                            size: size,
                            style: "default", 
                            imageUrl: item.imageUrl,
                            backgroundColor: nil,
                            requiresPurchase: false,
                            isPurchased: true,
                            configuration: [:]
                        )
                        
                        WidgetPresetPreviewView(
                            preset: widgetPreset,
                            onComplete: {
                                hasCompletedSetup = true
                                showPreview = false
                            }
                        )
                    }
                } else {
                    // その他のコンテンツタイプ（テンプレートなど）
                    ContentPreviewView(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        contentId: item.id,
                        contentType: contentType
                    )
                }
            }
        }
        .alert(isPresented: $hasCompletedSetup) {
            Alert(
                title: Text("設定完了"),
                message: Text("ウィジェットの設定が完了しました。ホーム画面に戻り、ウィジェットを追加してください。"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// プレビュー
#Preview {
    ContentItemView(
        item: ContentItem(
            title: "サンプルアイテム",
            imageUrl: "placeholder",
            category: TemplateCategory.popular,
            popularity: 100
        ),
        contentType: .template,
        index: 0
    )
}
