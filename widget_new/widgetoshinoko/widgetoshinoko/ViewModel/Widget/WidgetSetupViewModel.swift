import Foundation
import Combine
import GaudiyWidgetShared

class WidgetSetupViewModel: ObservableObject {
    // 入力
    private let preset: WidgetPreset
    private let widgetManager: WidgetManager
    
    // 出力
    @Published var selectedSize: WidgetSize = .small
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var setupComplete = false
    
    // 状態
    @Published var sizeLimits: [WidgetSize: Int] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(preset: WidgetPreset, widgetManager: WidgetManager = WidgetManager.shared) {
        self.preset = preset
        self.widgetManager = widgetManager
        
        // 各サイズの残りスロット数を計算
        updateSizeLimits()
    }
    
    func updateSizeLimits() {
        for size in WidgetSize.allCases {
            sizeLimits[size] = widgetManager.remainingSlots(for: size)
        }
    }
    
    func addWidget() {
        do {
            try widgetManager.addWidget(preset: preset, size: selectedSize)
            setupComplete = true
            updateSizeLimits()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    func isSizeAvailable(_ size: WidgetSize) -> Bool {
        return (sizeLimits[size] ?? 0) > 0
    }
    
    func getWidgetInstructions() -> String {
        return """
        ウィジェットを追加するには:
        1. ホーム画面を長押し
        2. 左上の「+」をタップ
        3. 「Widgetoshinoko」を選択
        4. 追加したいウィジェットを選択
        """
    }
}
