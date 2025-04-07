import SwiftUI
import FirebaseAnalytics
import GaudiyWidgetShared

struct TestAnalyticsView: View {
    @State private var logMessages: [String] = []
    
    var body: some View {
        VStack {
            Text("アナリティクステスト")
                .font(.headline)
                .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(logMessages, id: \.self) { message in
                        Text(message)
                            .font(.system(.body, design: .monospaced))
                            .padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color.black.opacity(0.05))
            .cornerRadius(8)
            .padding()
            
            Button("直接アナリティクス送信") {
                let timestamp = Date().timeIntervalSince1970
                addLog("直接送信開始: \(timestamp)")
                
                Analytics.logEvent("direct_test_event", parameters: [
                    "timestamp": timestamp
                ])
                
                addLog("直接送信完了")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("サービス経由で送信") {
                let timestamp = Date().timeIntervalSince1970
                addLog("サービス経由送信開始: \(timestamp)")
                
                AnalyticsService.shared.logEvent("service_test_event", parameters: [
                    "timestamp": timestamp
                ])
                
                addLog("サービス経由送信完了")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("UserDefaultsテスト") {
                let userDefaults = UserDefaults(suiteName: SharedConstants.UserDefaults.appGroupID)
                let testKey = "test_analytics_key"
                let testValue = "テスト値: \(Date().timeIntervalSince1970)"
                
                addLog("UserDefaults書き込み: \(testValue)")
                userDefaults?.set(testValue, forKey: testKey)
                
                if let readValue = userDefaults?.string(forKey: testKey) {
                    addLog("UserDefaults読み込み: \(readValue)")
                } else {
                    addLog("UserDefaults読み込み失敗")
                }
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("ログクリア") {
                logMessages.removeAll()
            }
            .padding()
        }
        .onAppear {
            addLog("画面表示: \(Date())")
        }
    }
    
    private func addLog(_ message: String) {
        let formattedMessage = "[\(dateFormatter.string(from: Date()))] \(message)"
        print(formattedMessage)
        logMessages.append(formattedMessage)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }
}
