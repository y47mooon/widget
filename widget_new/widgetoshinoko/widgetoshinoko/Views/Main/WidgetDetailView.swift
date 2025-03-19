import SwiftUI

// ウィジェット専用の詳細ビュー
struct WidgetDetailView: View {
    let title: String
    @State private var selectedSize: WidgetSize = .small
    // 表示するアイテム数を制御するための状態変数
    @State private var visibleItems: Int = 10
    
    var body: some View {
        VStack(spacing: 0) {
            // サイズ選択セグメントコントロール
            Picker("ウィジェットサイズ", selection: $selectedSize) {
                ForEach(WidgetSize.allCases, id: \.self) { size in
                    Text(size.rawValue)
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // ウィジェット一覧を最適化
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 16
                ) {
                    ForEach(0..<visibleItems, id: \.self) { index in
                        WidgetSizeView(
                            size: selectedSize,
                            title: "ダミーウィジェット \(index + 1)"  // タイトルを追加
                        )
                        .onAppear {
                            // 最後のアイテムが表示されたら、さらにアイテムを追加
                            if index == visibleItems - 1 && visibleItems < 20 {
                                visibleItems += 5
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationView {
        WidgetDetailView(title: "ウィジェット詳細")
    }
}
