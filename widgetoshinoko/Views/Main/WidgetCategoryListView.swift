import SwiftUI
import GaudiyWidgetShared

struct WidgetCategoryListView: View {
    @ObservedObject var viewModel: MainContentViewModel
    
    init(viewModel: MainContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 時計セクション
                GenericSectionView<ClockPreset, AnyView>(
                    title: "widget_clock".localized,
                    seeMoreText: "button_see_more".localized,
                    items: viewModel.clockPresets,
                    destination: ClockPresetListView(),
                    itemBuilder: { item, _ in
                        AnyView(
                            WidgetSizeView(size: .small)
                                .widgetFrame(for: .small)
                                .overlay(
                                    ClockWidgetView(size: .small, configuration: item.configuration)
                                )
                        )
                    }
                )
                
                // 天気セクション
                GenericSectionView<WidgetItem, AnyView>(
                    title: "widget_weather".localized,
                    seeMoreText: "button_see_more".localized,
                    items: viewModel.widgetItems.filter { $0.category == WidgetCategory.weather.rawValue },
                    destination: WidgetListView(
                        viewModel: WidgetListViewModel(category: .weather),
                        itemBuilder: { size in
                            WidgetSizeView(size: size)
                        }
                    ),
                    itemBuilder: { item, _ in
                        AnyView(
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 16) {
                                    ForEach(viewModel.widgetItems.filter { $0.category == WidgetCategory.weather.rawValue }) { widget in
                                        WidgetSizeView(size: .small)
                                            .frame(width: 100, height: 100)
                                            .overlay(
                                                Text(widget.title)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .padding(.horizontal, 8)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        )
                    }
                )
                
                // カレンダーセクション
                GenericSectionView<WidgetItem, AnyView>(
                    title: "widget_calendar".localized,
                    seeMoreText: "button_see_more".localized,
                    items: viewModel.widgetItems.filter { $0.category == WidgetCategory.calendar.rawValue },
                    destination: WidgetListView(
                        viewModel: WidgetListViewModel(category: .calendar),
                        itemBuilder: { size in
                            WidgetSizeView(size: size)
                        }
                    ),
                    itemBuilder: { item, _ in
                        AnyView(
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 16) {
                                    ForEach(viewModel.widgetItems.filter { $0.category == WidgetCategory.calendar.rawValue }) { widget in
                                        WidgetSizeView(size: .small)
                                            .frame(width: 100, height: 100)
                                            .overlay(
                                                Text(widget.title)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .padding(.horizontal, 8)
                                            )
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
    }
    
    // ウィジェットの横幅を計算するヘルパーメソッド
    private func calculateWidgetWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2  // 画面の左右パディング
        let spacing: CGFloat = 8       // アイテム間の間隔
        let itemCount: CGFloat = 5     // 横に表示するアイテム数
        let totalSpacing = spacing * (itemCount - 1)
        
        return (screenWidth - padding - totalSpacing) / itemCount
    }
    
    // ダミーデータを生成する関数
    private func getDummyWidgets(for category: WidgetCategory) -> [WidgetItem] {
        return (0..<5).map { index in
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
}

#Preview {
    WidgetCategoryListView(viewModel: MainContentViewModel())
}
