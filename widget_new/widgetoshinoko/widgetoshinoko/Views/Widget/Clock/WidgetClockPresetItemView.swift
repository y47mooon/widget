import Foundation
import SwiftUI
import GaudiyWidgetShared

struct WidgetPresetItemView: View {
    let preset: WidgetPreset
    
    var body: some View {
        ZStack {
            // 背景
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 2)
            
            // コンテンツ
            VStack(spacing: 4) {
                // プリセットタイプに応じた表示
                switch preset.type {
                case .analogClock:
                    // アナログ時計の場合
                    ClockWidgetView(
                        size: preset.size,
                        configuration: preset.toClockConfiguration()
                    )
                    .frame(width: 100, height: 100)
                case .digitalClock:
                    // デジタル時計の場合
                    VStack {
                        Text("13:52")
                            .font(.system(size: 24, weight: .medium, design: .monospaced))
                            .foregroundColor(.black)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.white)
                case .calendar:
                    // カレンダーの場合
                    VStack {
                        Text("2025年4月7日")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.white)
                    .cornerRadius(8)
                case .photo:
                    // 写真の場合
                    AsyncImage(url: URL(string: preset.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo").font(.largeTitle)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                default:
                    // その他の場合
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
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(systemName: "photo").font(.largeTitle)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                
                // タイトル
                Text(preset.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 説明
                Text(preset.description)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
            
            // 有料アイテムの場合はロックアイコン
            if preset.requiresPurchase && !preset.isPurchased {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(8)
            }
        }
    }
}

// WidgetTypeの拡張（必要な場合のみ）
extension WidgetType {
    var iconName: String {
        switch self {
        case .analogClock: return "clock"
        case .digitalClock: return "clock.fill"
        case .calendar: return "calendar"
        case .photo: return "photo"
        case .weather: return "cloud.sun.fill"
        default: return "square"
        }
    }
}

#Preview {
    WidgetPresetItemView(preset: WidgetPreset(
        id: UUID(),
        title: "サンプルプリセット",
        description: "説明文",
        type: .analogClock,
        size: .small,
        style: "default",
        imageUrl: "",
        backgroundColor: nil,
        requiresPurchase: false,
        isPurchased: false,
        configuration: [:]
    ))
}
