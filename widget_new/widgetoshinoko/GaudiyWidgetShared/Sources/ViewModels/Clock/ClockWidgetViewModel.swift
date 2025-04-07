import SwiftUI
import Combine

public class ClockWidgetViewModel: ObservableObject {
    @Published private(set) var currentTime = Date()
    @Published public var configuration: ClockConfiguration
    
    private var timer: AnyCancellable?
    private let formatter: DateFormatter
    
    public init(configuration: ClockConfiguration = ClockConfiguration(
        style: .digital,
        imageUrl: "",
        size: .small
    )) {
        self.configuration = configuration
        self.formatter = DateFormatter()
        self.formatter.locale = Locale(identifier: "ja_JP")
        setupTimer()
    }
    
    private func setupTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.currentTime = Date()
            }
    }
    
    public var timeString: String {
        formatter.dateFormat = configuration.showSeconds ? "HH:mm:ss" : "HH:mm"
        return formatter.string(from: currentTime)
    }
    
    deinit {
        timer?.cancel()
    }
}
