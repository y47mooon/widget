import SwiftUI

struct ClockPresetListView: View {
    @StateObject private var viewModel: WidgetListViewModel
    
    init() {
        // 時計専用のViewModelを初期化
        _viewModel = StateObject(wrappedValue: WidgetListViewModel(
            repository: MockWidgetRepository(),
            category: .clock
        ))
    }
    
    var body: some View {
        WidgetListView(
            viewModel: viewModel,
            itemBuilder: { size in
                WidgetSizeView(size: size)
                    .overlay(
                        ClockWidgetView(size: size)
                    )
            }
        )
        .navigationTitle("時計ウィジェット")
    }
}

// 時計の表示部分
struct ClockWidgetView: View {
    let size: WidgetSize
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(timeString)
                .font(.system(size: fontSize, weight: .medium, design: .rounded))
                .monospacedDigit()
            if size != .small {
                Text(dateString)
                    .font(.system(size: fontSize * 0.4))
                    .foregroundColor(.gray)
            }
        }
        .onReceive(timer) { input in
            currentTime = input
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentTime)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日(E)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: currentTime)
    }
    
    private var fontSize: CGFloat {
        switch size {
        case .small: return 24
        case .medium: return 32
        case .large: return 40
        }
    }
}
