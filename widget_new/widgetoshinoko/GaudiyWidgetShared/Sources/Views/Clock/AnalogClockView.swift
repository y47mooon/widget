import SwiftUI

public struct AnalogClockView: View {
    // 動的な時刻更新を削除
    // @State private var currentTime = Date()
    // let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // プロパティを変数にする（letからvarに変更）
    private var hour: Double
    private var minute: Double
    private var second: Double
    
    public var body: some View {
        ZStack {
            // 時計の文字盤
            Circle()
                .stroke(Color.gray, lineWidth: 2)
            
            // 時間マーカー
            ForEach(0..<12) { hour in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 2, height: hour % 3 == 0 ? 10 : 5)
                    .offset(y: -35)
                    .rotationEffect(.degrees(Double(hour) * 30))
            }
            
            // 時針
            Rectangle()
                .fill(Color.black)
                .frame(width: 3, height: 20)
                .offset(y: -10)
                .rotationEffect(getHourAngle())
            
            // 分針
            Rectangle()
                .fill(Color.black)
                .frame(width: 2, height: 30)
                .offset(y: -15)
                .rotationEffect(getMinuteAngle())
            
            // 秒針
            Rectangle()
                .fill(Color.red)
                .frame(width: 1, height: 35)
                .offset(y: -17.5)
                .rotationEffect(getSecondAngle())
            
            // 中心点
            Circle()
                .fill(Color.black)
                .frame(width: 6, height: 6)
        }
        // タイマーを使用しないように修正
        // .onReceive(timer) { input in
        //     currentTime = input
        // }
    }
    
    // 固定角度を返すメソッド
    private func getHourAngle() -> Angle {
        let anglePerHour = 30.0  // 360度÷12時間
        let anglePerMinute = 0.5  // 30度÷60分
        let hourAngle = hour * anglePerHour + minute * anglePerMinute
        return .degrees(hourAngle)
    }
    
    private func getMinuteAngle() -> Angle {
        let anglePerMinute = 6.0  // 360度÷60分
        return .degrees(minute * anglePerMinute)
    }
    
    private func getSecondAngle() -> Angle {
        let anglePerSecond = 6.0  // 360度÷60秒
        return .degrees(second * anglePerSecond)
    }
    
    // 初期化メソッド
    public init(hour: Double = 10, minute: Double = 10, second: Double = 0) {
        self.hour = hour
        self.minute = minute
        self.second = second
    }
}

struct ClockHand: Shape {
    let length: CGFloat
    let width: CGFloat
    let angle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        
        path.move(to: center)
        let endX = center.x + sin(angle.radians) * length
        let endY = center.y - cos(angle.radians) * length
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        return path
    }
}
