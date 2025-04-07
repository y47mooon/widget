import SwiftUI

public struct DigitalClockView: View {
    // 固定表示する時刻と書式
    private let timeText: String
    private let fontSize: CGFloat
    private let textColor: Color
    
    public var body: some View {
        Text(timeText)
            .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
            .foregroundColor(textColor)
    }
    
    // デフォルトでは13:52を表示
    public init(timeText: String = "13:52", fontSize: CGFloat = 24, textColor: Color = .black) {
        self.timeText = timeText
        self.fontSize = fontSize
        self.textColor = textColor
    }
}

#Preview {
    DigitalClockView()
}
