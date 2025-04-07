import SwiftUI
import GaudiyWidgetShared
import Firebase
import FirebaseFirestore

struct DebugMenuView: View {
    @State private var showingUserDefaults = false
    @State private var userDefaultsOutput = ""
    @State private var isLoadingPresets = false
    @State private var statusMessage = ""
    
    var body: some View {
        VStack {
            Button("UserDefaultsの内容を確認") {
                checkUserDefaults()
                showingUserDefaults = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("デフォルトのプリセットを確認") {
                checkDefaultPresets()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Firebaseのプリセットを確認") {
                isLoadingPresets = true
                statusMessage = "プリセットを取得中..."
                Task {
                    await checkFirebasePresets()
                    isLoadingPresets = false
                    statusMessage = "プリセット取得完了"
                    // 確認後にUserDefaultsも更新して確認
                    checkUserDefaults()
                    showingUserDefaults = true
                }
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isLoadingPresets)
            
            if isLoadingPresets || !statusMessage.isEmpty {
                Text(statusMessage)
                    .padding()
                    .foregroundColor(isLoadingPresets ? .orange : .green)
            }
            
            if showingUserDefaults {
                ScrollView {
                    Text(userDefaultsOutput)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                }
                .frame(height: 300)
            }
        }
        .padding()
        .navigationTitle("デバッグメニュー")
    }
    
    private func checkUserDefaults() {
        // UserDefaults情報をキャプチャ
        let logCapture = LogCapture()
        UserDefaultsDebugger.printSavedWidgets()
        userDefaultsOutput = logCapture.getLog()
    }
    
    private func checkDefaultPresets() {
        let repository = WidgetClockPresetRepository()
        let defaultPresets = repository.getDefaultPresets()
        
        // デフォルトプリセットの情報をキャプチャ
        let logCapture = LogCapture()
        print("=== デフォルトのプリセット一覧 ===")
        for preset in defaultPresets {
            print("タイトル: \(preset.title)")
            print("スタイル: \(preset.style)")
            print("サイズ: \(preset.size)")
            print("カテゴリ: \(preset.category)")
            print("--------------------------")
        }
        userDefaultsOutput = logCapture.getLog()
        showingUserDefaults = true
    }
    
    private func checkFirebasePresets() async {
        // Firebaseのリポジトリを使用
        let repository = FirebaseClockPresetRepository()
        
        do {
            let presets = try await repository.fetchPresets()
            
            // プリセット情報をキャプチャ
            let logCapture = LogCapture()
            print("=== Firebaseのプリセット一覧（\(presets.count)件）===")
            for preset in presets {
                print("タイトル: \(preset.title)")
                print("スタイル: \(preset.style)")
                print("サイズ: \(preset.size)")
                print("カテゴリ: \(preset.category)")
                print("--------------------------")
            }
            
            // 表示用に情報を更新
            DispatchQueue.main.async {
                self.userDefaultsOutput = logCapture.getLog()
            }
        } catch {
            print("プリセット取得エラー: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.statusMessage = "エラー: \(error.localizedDescription)"
            }
        }
    }
}

// ログキャプチャ用のユーティリティクラス
class LogCapture: TextOutputStream {
    private var logString = ""
    
    func write(_ string: String) {
        logString.append(string)
    }
    
    func getLog() -> String {
        return logString
    }
    
    init() {
        // 標準出力をリダイレクト
        let pipe = Pipe()
        let originalStdout = dup(FileHandle.standardOutput.fileDescriptor)
        dup2(pipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
        
        // ログをキャプチャするための準備
        pipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            let data = fileHandle.availableData
            if let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self?.write(string)
                }
            }
        }
    }
}

struct DebugMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuView()
    }
} 