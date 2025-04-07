import SwiftUI
import GaudiyWidgetShared

struct ClockPresetListView: View {
    @StateObject private var viewModel = ClockPresetsViewModel()
    @State private var selectedSize: WidgetSize = .small
    
    var body: some View {
        VStack {
            // サイズ選択セグメント
            Picker("サイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.displayName).tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // プリセット一覧
            ScrollView {
                // グリッドレイアウトを使用
                LazyVGrid(columns: getColumns(for: selectedSize), spacing: 16) {
                    // サイズでフィルタリングしたプリセットを表示
                    let filteredPresets = getPresets(for: selectedSize)
                    
                    ForEach(filteredPresets) { preset in
                        // 直接プレビューに遷移するよう変更
                        Button(action: {
                            showPreview(for: preset)
                        }) {
                            ClockPresetGridItemView(preset: preset)
                                .frame(height: getItemHeight(for: selectedSize))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle("時計")
        .onAppear {
            // 非同期メソッドを呼び出す
            Task {
                await viewModel.fetchPresets()
            }
        }
    }
    
    // プレビューを表示するメソッド
    private func showPreview(for preset: ClockPreset) {
        let widgetPreset = convertToWidgetPreset(preset)
        
        // ホストビューコントローラを取得
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        // ナビゲーションビューをラップしたWidgetPresetPreviewViewをモーダル表示
        let previewView = WidgetPresetPreviewView(preset: widgetPreset)
        let hostingController = UIHostingController(rootView: 
            NavigationView {
                previewView
            }
        )
        
        rootViewController.present(hostingController, animated: true)
    }
    
    // ClockPresetをWidgetPresetに変換する関数
    private func convertToWidgetPreset(_ clockPreset: ClockPreset) -> WidgetPreset {
        return WidgetPreset(
            id: clockPreset.id,
            title: clockPreset.title,
            description: clockPreset.description,
            type: clockPreset.style == .analog ? .analogClock : .digitalClock,
            size: clockPreset.size,
            style: clockPreset.style.rawValue,
            imageUrl: clockPreset.imageUrl ?? "",
            backgroundColor: nil,
            requiresPurchase: false,
            isPurchased: true,
            configuration: [
                "style": clockPreset.style.rawValue,
                "showSeconds": String(clockPreset.showSeconds),
                "textColor": clockPreset.textColor ?? "#000000",
                "fontSize": String(clockPreset.fontSize ?? 16)
            ]
        )
    }
    
    // サイズに応じたプリセットを取得（サイズごとに十分なプリセットがない場合はサンプルを追加）
    private func getPresets(for size: WidgetSize) -> [ClockPreset] {
        var presets = viewModel.presets.filter { $0.size == size }
        
        // プリセットが少ない場合はサンプルデータを追加
        if presets.count < 4 {
            // 足りない分のサンプルデータを生成
            let sampleCount = 4 - presets.count
            for i in 0..<sampleCount {
                let isAnalog = (i % 2 == 0) // 交互にアナログとデジタル
                
                let samplePreset = ClockPreset(
                    id: UUID(),
                    title: isAnalog ? "アナログ時計 \(i+1)" : "デジタル時計 \(i+1)",
                    description: isAnalog ? "クラシックなデザイン" : "シンプルなデザイン",
                    style: isAnalog ? .analog : .digital,
                    size: size,
                    imageUrl: "",
                    textColor: isAnalog ? "#000000" : "#FFFFFF",
                    fontSize: size == .small ? 14 : (size == .medium ? 18 : 24),
                    showSeconds: true,
                    category: isAnalog ? .classic : .simple
                )
                presets.append(samplePreset)
            }
        }
        
        return presets
    }
    
    // サイズに応じたカラム設定を取得
    private func getColumns(for size: WidgetSize) -> [GridItem] {
        switch size {
        case .small, .medium:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .large:
            return [GridItem(.flexible())]
        }
    }
    
    // サイズに応じたアイテムの高さを取得
    private func getItemHeight(for size: WidgetSize) -> CGFloat {
        switch size {
        case .small: return 150
        case .medium: return 170
        case .large: return 250
        }
    }
}

// グリッド表示用のアイテムビュー
struct ClockPresetGridItemView: View {
    let preset: ClockPreset
    
    var body: some View {
        VStack {
            // 時計のプレビュー
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .aspectRatio(1, contentMode: .fit)
                
                if preset.style == .analog {
                    // アナログ時計
                    AnalogClockView()
                        .frame(width: 100, height: 100)
                } else {
                    // デジタル時計
                    DigitalClockView()
                        .frame(width: 100, height: 100)
                }
            }
            
            // タイトル
            Text(preset.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 4)
            
            // 説明
            Text(preset.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
                .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
