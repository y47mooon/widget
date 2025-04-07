import SwiftUI
import Combine
import GaudiyWidgetShared

public struct ClockWidgetView: View {
    @StateObject private var viewModel: ClockWidgetViewModel
    private let size: WidgetSize
    private let configuration: ClockConfiguration
    
    public init(size: WidgetSize, configuration: ClockConfiguration) {
        self.size = size
        self.configuration = configuration
        _viewModel = StateObject(wrappedValue: ClockWidgetViewModel(configuration: configuration))
    }
    
    public var body: some View {
        ZStack {
            // 背景色の部分を削除
            
            // 時計表示
            Text(viewModel.timeString)
                .font(.system(size: WidgetLayoutManager.getFontSize(
                    for: viewModel.configuration.size, 
                    configuration: viewModel.configuration
                )))
                .foregroundColor(
                    Color(hex: viewModel.configuration.textColor ?? "#000000")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: 
                    WidgetLayoutManager.getTextAlignment(for: viewModel.configuration.size)
                )
                .padding(
                    WidgetLayoutManager.getPadding(for: viewModel.configuration.size)
                )
        }
    }
}

private struct TimeDisplayView: View {
    @ObservedObject var viewModel: ClockWidgetViewModel
    
    var body: some View {
        Text(viewModel.timeString)
            .font(.system(size: viewModel.configuration.fontSize))
            .foregroundColor(Color(hex: viewModel.configuration.textColor))
    }
}
