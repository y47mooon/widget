import SwiftUI
import GaudiyWidgetShared

struct SavedWidgetsView: View {
    @StateObject private var widgetManager = WidgetManager.shared
    @State private var selectedType: WidgetType = .analogClock
    
    var body: some View {
        VStack {
            // ウィジェットタイプ選択
            Picker("ウィジェットタイプ", selection: $selectedType) {
                ForEach(WidgetType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // 選択されたタイプのウィジェット一覧
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(widgetManager.getSavedWidgets(for: selectedType)) { widget in
                        SavedWidgetItemView(widget: widget)
                    }
                }
                .padding()
            }
        }
    }
}

// 保存済みウィジェット表示用ビュー
struct SavedWidgetItemView: View {
    let widget: SavedWidget
    @ObservedObject private var widgetManager = WidgetManager.shared
    
    var body: some View {
        ZStack {
            // ウィジェットプレビュー
            if let preset = widgetManager.getPreset(for: widget.presetId) {
                ZStack {
                    // プリセットタイプに応じた表示
                    switch preset.type {
                    case .analogClock:
                        ClockWidgetView(
                            size: widget.size,
                            configuration: preset.toClockConfiguration()
                        )
                        .frame(width: widget.size.previewWidth, height: widget.size.previewHeight)
                    case .calendar:
                        CalendarWidgetView(size: widget.size, configuration: preset.configuration)
                            .frame(width: widget.size.previewWidth, height: widget.size.previewHeight)
                    case .photo:
                        AsyncImage(url: URL(string: preset.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo").font(.largeTitle)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: widget.size.previewWidth, height: widget.size.previewHeight)
                    default:
                        // その他のウィジェットタイプの表示
                        if preset.imageUrl.isEmpty {
                            Image(systemName: preset.type.iconName)
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        } else {
                            AsyncImage(url: URL(string: preset.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fit)
                                case .failure:
                                    Image(systemName: "photo").font(.largeTitle)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    
                    // ウィジェットタイトル
                    Text(preset.title)
                        .font(.caption)
                        .padding(4)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .position(x: widget.size.previewWidth / 2, y: widget.size.previewHeight - 15)
                }
            } else {
                // プリセットが見つからない場合のフォールバック表示
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "questionmark")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
            }
        }
        .frame(width: 150, height: 150)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

// ウィジェット追加手順説明ビュー
struct WidgetInstructionsView: View {
    let size: WidgetSize
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // タイトル
            Text("ウィジェットを設定")
                .font(.headline)
                .padding()
            
            // 説明
            VStack(alignment: .leading, spacing: 20) {
                Text("入れ替えたいウィジェットを選択してください。一つのサイズにつき20個まで自由に設定できるウィジェットの枠が用意されています。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // ウィジェット枠イメージ
                HStack {
                    Spacer()
                    VStack {
                        Text("#\(getNextWidgetNumber()) \(size.displayName) ウィジェット")
                            .font(.headline)
                            .padding(.vertical, 10)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 200, height: 200)
                            
                            VStack {
                                Text("設定完了")
                                    .padding(.bottom, 4)
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
            }
            
            Spacer()
            
            // 閉じるボタン
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
    }
    
    private func getNextWidgetNumber() -> Int {
        return WidgetManager.shared.getWidgets(for: size).count + 1
    }
}
