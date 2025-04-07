import SwiftUI
import GaudiyWidgetShared

struct WidgetItemView: View {
    let item: WidgetItem
    let size: WidgetSize // サイズを追加
    @State private var showPreview = false
    @State private var hasCompletedSetup = false
    
    // デフォルトサイズは.small
    init(item: WidgetItem, size: WidgetSize = .small) {
        self.item = item
        self.size = size
    }
    
    var body: some View {
        Button(action: {
            showPreview = true
        }) {
            ZStack {
                // 背景
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                
                // ウィジェットタイプに応じた表示
                if item.category == WidgetCategory.clock.rawValue {
                    let style: ClockStyle = item.title.contains("アナログ") ? .analog : .digital
                    ClockWidgetView(
                        size: size,
                        configuration: ClockConfiguration(
                            style: style,
                            imageUrl: item.imageUrl,
                            size: size
                        )
                    )
                } else {
                    // その他のウィジェット表示（仮）
                    Text(item.title)
                        .font(.caption)
                }
                
                // 有料アイテムの場合はロックアイコン
                if item.requiresPurchase && !item.isPurchased {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(8)
                }
            }
        }
        .sheet(isPresented: $showPreview) {
            NavigationView {
                // WidgetItemからWidgetPresetを作成
                let widgetType: WidgetType = {
                    if item.category.contains("Clock") {
                        return item.title.contains("アナログ") ? .analogClock : .digitalClock
                    } else if item.category.contains("Weather") {
                        return .weather
                    } else {
                        return .calendar
                    }
                }()

                let preset = WidgetPreset(
                    id: item.id,
                    title: item.title,
                    description: item.description ?? "",
                    type: widgetType,
                    size: size,
                    style: "default",
                    imageUrl: item.imageUrl,
                    backgroundColor: nil,
                    requiresPurchase: item.requiresPurchase,
                    isPurchased: item.isPurchased,
                    configuration: [:]
                )
                
                // 課金が必要なアイテムの場合
                if item.requiresPurchase && !item.isPurchased {
                    // 未購入の有料アイテム
                    WidgetPresetPreviewView(preset: preset)
                        .opacity(0.7)
                        .overlay(
                            VStack {
                                Image(systemName: "lock.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                                
                                Text("購入が必要です")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                            }
                        )
                } else {
                    // 無料または購入済みアイテム
                    WidgetPresetPreviewView(
                        preset: preset,
                        onComplete: {
                            showPreview = false
                            hasCompletedSetup = true
                        }
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

// ウィジェット表示スタイルの列挙型
enum WidgetDisplayStyle {
    case standard    // 標準表示（既存の実装）
    case rectangular // 長方形（横長）
    case square      // 正方形（アイコンサイズ）
    case mixed(index: Int) // 混合表示（インデックスに基づく交互表示）
}

#Preview {
    ScrollView(.horizontal) {
        HStack(spacing: DesignConstants.Layout.smallSpacing) {
            ForEach(0..<5) { index in
                WidgetItemView(item: WidgetItem.preview)
            }
        }
        .padding()
    }
}
