import Foundation
import SwiftUI
import GaudiyWidgetShared

struct WidgetCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    @State private var isLoading = false
    
    init(viewModel: MainContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 時計セクション
                GenericSectionView<ClockPreset, AnyView>(
                    title: "時計",
                    seeMoreText: "もっと見る",
                    items: !viewModel.clockPresets.isEmpty ? viewModel.clockPresets : getDummyClockPresets(),
                    destination: ClockPresetListView(),
                    itemBuilder: { item, _ in
                        AnyView(
                            HStack(spacing: 16) {
                                ForEach((!viewModel.clockPresets.isEmpty ? viewModel.clockPresets : getDummyClockPresets()).prefix(3), id: \.id) { preset in
                                    ClockPresetItemView(preset: preset)
                                        .frame(width: 110, height: 160)
                                }
                            }
                            .padding(.horizontal)
                        )
                    }
                )
                
                // カレンダーセクション
                GenericSectionView<WidgetItem, AnyView>(
                    title: "カレンダー",
                    seeMoreText: "もっと見る",
                    items: viewModel.widgetItems.filter { $0.category == WidgetCategory.calendar.rawValue },
                    destination: WidgetListView(
                        viewModel: WidgetListViewModel(category: .calendar),
                        itemBuilder: { size in
                            WidgetSizeView(size: size)
                        }
                    ),
                    itemBuilder: { item, _ in
                        AnyView(
                            HStack(spacing: 16) {
                                let calendarWidgets = viewModel.widgetItems.filter { $0.category == WidgetCategory.calendar.rawValue }.isEmpty ?
                                    getDummyWidgets(for: .calendar) :
                                    viewModel.widgetItems.filter { $0.category == WidgetCategory.calendar.rawValue }
                                
                                ForEach(calendarWidgets.prefix(3)) { widget in
                                    CalendarPresetItemView(widget: widget)
                                        .frame(width: 110, height: 160)
                                }
                            }
                            .padding(.horizontal)
                        )
                    }
                )
                
                // メモセクション
                GenericSectionView<WidgetItem, AnyView>(
                    title: "メモ",
                    seeMoreText: "もっと見る",
                    items: viewModel.widgetItems.filter { $0.category == WidgetCategory.memo.rawValue },
                    destination: WidgetListView(
                        viewModel: WidgetListViewModel(category: .memo),
                        itemBuilder: { size in
                            WidgetSizeView(size: size)
                        }
                    ),
                    itemBuilder: { item, _ in
                        AnyView(
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.fixed(120))], spacing: 16) {
                                    let memoWidgets = viewModel.widgetItems.filter { $0.category == WidgetCategory.memo.rawValue }.isEmpty ?
                                        getDummyWidgets(for: .memo) :
                                        viewModel.widgetItems.filter { $0.category == WidgetCategory.memo.rawValue }
                                    
                                    if memoWidgets.isEmpty {
                                        // データがない場合はプレースホルダーを表示
                                        ForEach(0..<3, id: \.self) { _ in
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: UIScreen.main.bounds.width - 40, height: 100)
                                                .cornerRadius(12)
                                        }
                                    } else {
                                        ForEach(memoWidgets) { widget in
                                            MemoPresetItemView(widget: widget)
                                                .frame(width: UIScreen.main.bounds.width - 40)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        )
                    }
                )
                
                // 写真セクション
                GenericSectionView<WidgetItem, AnyView>(
                    title: "写真",
                    seeMoreText: "もっと見る",
                    items: viewModel.widgetItems.filter { $0.category == "widget_photo" },
                    destination: WidgetListView(
                        viewModel: WidgetListViewModel(category: .popular), // 適切なカテゴリーがない場合
                        itemBuilder: { size in
                            WidgetSizeView(size: size)
                        }
                    ),
                    itemBuilder: { item, _ in
                        AnyView(
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.fixed(120))], spacing: 16) {
                                    let photoWidgets = getDummyPhotoWidgets()
                                    
                                    ForEach(photoWidgets) { widget in
                                        PhotoPresetItemView(widget: widget)
                                            .frame(width: UIScreen.main.bounds.width - 40)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        )
                    }
                )
            }
            .padding(.vertical)
        }
        .onAppear {
            // 画面表示時にデータを再読み込み
            isLoading = true
            Task {
                if viewModel.widgetItems.isEmpty {
                    await viewModel.loadAllData()
                }
                isLoading = false
            }
        }
        // ロード中の表示
        .overlay(
            Group {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white.opacity(0.7))
                }
            }
        )
    }
    
    // ダミーデータを生成する関数
    private func getDummyWidgets(for category: WidgetCategory) -> [WidgetItem] {
        return (0..<3).map { index in
            WidgetItem(
                id: UUID(),
                title: "\(category.displayName) \(index + 1)",
                description: "ダミーの説明文です",
                imageUrl: "placeholder",
                category: category.rawValue,
                popularity: 100,
                createdAt: Date()
            )
        }
    }
    
    // ダミーの写真ウィジェットを生成
    private func getDummyPhotoWidgets() -> [WidgetItem] {
        return (0..<3).map { index in
            WidgetItem(
                id: UUID(),
                title: "写真ウィジェット \(index + 1)",
                description: "お気に入りの写真を表示します",
                imageUrl: "photo_placeholder",
                category: "widget_photo",
                popularity: 100,
                createdAt: Date()
            )
        }
    }
    
    // ダミーの時計プリセットを生成
    private func getDummyClockPresets() -> [ClockPreset] {
        return (0..<3).map { index in
            ClockPreset(
                id: UUID(),
                title: "時計プリセット \(index + 1)",
                description: "サンプルの時計デザイン",
                style: index % 2 == 0 ? .analog : .digital,
                size: .small,
                imageUrl: "clock_preset_\(index)",
                textColor: "#000000",
                fontSize: 14.0,
                showSeconds: false,
                category: .simple,
                createdBy: "system"
            )
        }
    }
}

#Preview {
    WidgetCategoryListView(viewModel: MainContentViewModel())
}
