import Foundation
import SwiftUI
import GaudiyWidgetShared
import WidgetKit

struct WidgetPresetDetailView: View {
    let preset: WidgetPreset
    @Environment(\.presentationMode) var presentationMode
    @State private var showError = false
    @State private var showSuccess = false
    @State private var errorMessage = ""
    @State private var isShowingPurchaseAlert = false
    @State private var isWidgetSaved = false
    @State private var showSavedMessage = false
    @State private var showWidgetInstructions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // プレビュー画像
                AsyncImage(url: URL(string: preset.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 200)
                .cornerRadius(12)
                .padding()
                
                // ウィジェット情報
                VStack(alignment: .leading, spacing: 10) {
                    Text(preset.title)
                        .font(.title2)
                        .bold()
                    
                    Text(preset.description)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Text("サイズ: \(preset.size.rawValue)")
                        .font(.subheadline)
                }
                .padding()
                
                // 適用ボタン
                Button(action: {
                    if preset.requiresPurchase && !preset.isPurchased {
                        isShowingPurchaseAlert = true
                    } else {
                        applyWidget()
                    }
                }) {
                    Text(preset.requiresPurchase && !preset.isPurchased ? "購入して適用" : "適用")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button("設定") {
                    do {
                        // プリセット情報をメッセージとして保存
                        let message = "プリセット: \(preset.title) (\(preset.size.rawValue))"
                        WidgetMessageService.shared.saveMessage(message)
                        
                        // 保存完了メッセージを表示
                        isWidgetSaved = true
                        showSavedMessage = true
                        
                        // ウィジェットの設定方法を表示
                        showWidgetInstructions = true
                        
                        // ウィジェットにプリセットを送信
                        savePresetToWidget(preset)
                    } catch {
                        // エラー処理
                        showError = true
                        errorMessage = error.localizedDescription
                    }
                }
                
                Spacer()
            }
            .alert(isPresented: $isShowingPurchaseAlert) {
                Alert(
                    title: Text("ウィジェットの購入"),
                    message: Text("\(preset.title)を購入しますか？"),
                    primaryButton: .default(Text("購入")) {
                        purchaseWidget()
                    },
                    secondaryButton: .cancel(Text("キャンセル"))
                )
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("エラー"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("成功"),
                    message: Text("ウィジェットを追加できます"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showSavedMessage) {
                Alert(
                    title: Text("保存完了"),
                    message: Text("ウィジェットが保存されました"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showWidgetInstructions) {
                Alert(
                    title: Text("ウィジェットの設定方法"),
                    message: Text("ここにウィジェットの設定方法を表示"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarTitle("プレビュー", displayMode: .inline)
            .navigationBarItems(
                leading: Button("閉じる") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func applyWidget() {
        Task {
            do {
                let viewModel = WidgetPresetViewModel()
                try await viewModel.saveWidget(preset)
                showSuccess = true
                
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    private func purchaseWidget() {
        // 購入処理の実装
        // TODO: 実際の購入処理を実装
    }
    
    // プリセットをウィジェットに送信する
    func savePresetToWidget(_ preset: WidgetPreset) {
        // プリセット情報をJSONに変換
        let presetData: [String: Any] = [
            "id": preset.id.uuidString,
            "title": preset.title,
            "type": preset.type.rawValue,
            "size": preset.size.rawValue,
            // 他の必要な情報
        ]
        
        // JSONデータに変換
        if let jsonData = try? JSONSerialization.data(withJSONObject: presetData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            // App Group経由で保存
            let userDefaults = UserDefaults(suiteName: "group.gaudiy.widgetoshinoko")
            userDefaults?.set(jsonString, forKey: "selected_preset")
            
            // ウィジェットを更新
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
