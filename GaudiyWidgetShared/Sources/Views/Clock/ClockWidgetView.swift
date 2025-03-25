import SwiftUI
import Combine

public struct ClockWidgetView: View {
    @StateObject private var viewModel: ClockWidgetViewModel
    private let size: WidgetSize
    
    public init(size: WidgetSize, configuration: ClockConfiguration) {
        self.size = size
        _viewModel = StateObject(wrappedValue: ClockWidgetViewModel(configuration: configuration))
    }
    
    public var body: some View {
        Group {
            switch viewModel.configuration.style {
            case .digital:
                TimeDisplayView(viewModel: viewModel)
            case .analog:
                TimeDisplayView(viewModel: viewModel)
            case .minimal:
                TimeDisplayView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(SharedConstants.Layout.defaultPadding)
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
