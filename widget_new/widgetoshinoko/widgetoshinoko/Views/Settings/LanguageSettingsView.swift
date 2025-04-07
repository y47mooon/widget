import SwiftUI

struct LanguageSettingsView: View {
    @State private var selectedLanguage: LanguageService.AppLanguage
    @Environment(\.presentationMode) var presentationMode
    @State private var needsRestart = false
    
    init() {
        _selectedLanguage = State(initialValue: LanguageService.shared.currentLanguage)
    }
    
    var body: some View {
        List {
            Section(header: Text("settings_language_header".localized)) {
                ForEach(LanguageService.AppLanguage.allCases, id: \.self) { language in
                    Button(action: {
                        if selectedLanguage != language {
                            selectedLanguage = language
                            LanguageService.shared.setLanguage(language)
                            needsRestart = true
                        }
                    }) {
                        HStack {
                            Text(language.displayName)
                            Spacer()
                            if selectedLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            
            if needsRestart {
                Section(footer: Text("settings_language_restart_note".localized)) {
                    Button(action: {
                        // アプリを再起動するようシステムに通知（実際には実装できないためフィードバックのみ）
                        exit(0) // 実際の製品では使用しません
                    }) {
                        Text("settings_restart_app".localized)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("settings_language_title".localized)
        .onDisappear {
            // 画面が閉じられる時の処理
            if needsRestart {
                // ここで言語変更の通知などを行う
            }
        }
    }
} 