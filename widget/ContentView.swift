//
//  ContentView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/02/26.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var widgetData: WidgetData
    
    init() {
        // WidgetDataServiceからデータを読み込む
        _widgetData = State(initialValue: WidgetDataService.shared.loadWidgetData())
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreenView(widgetData: $widgetData)
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
                .tag(0)
            
            WidgetGalleryView(widgetData: $widgetData)
                .tabItem {
                    Label("ウィジェット", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
            
            ThemeSettingsView(widgetData: $widgetData)
                .tabItem {
                    Label("テーマ", systemImage: "paintpalette.fill")
                }
                .tag(2)
            
            ProfileView(widgetData: $widgetData)
                .tabItem {
                    Label("プロフィール", systemImage: "person.fill")
                }
                .tag(3)
        }
        .onChange(of: widgetData) { newValue in
            // データが変更されたらWidgetDataServiceに保存
            WidgetDataService.shared.saveWidgetData(newValue)
        }
    }
}

struct HomeScreenView: View {
    @Binding var widgetData: WidgetData
    @State private var isEditing = false
    @State private var selectedItem: UUID?
    @State private var showingAddItemSheet = false
    
    var body: some View {
        ZStack {
            // 背景画像
            if let selectedTheme = widgetData.homeScreenThemes.first(where: { $0.isSelected }) {
                Image(selectedTheme.backgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            }
            
            // ホーム画面アイテム
            VStack {
                HStack {
                    Text("9:41")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "wifi")
                        Image(systemName: "battery.100")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // アイテムグリッド
                ZStack {
                    ForEach(widgetData.homeScreenItems) { item in
                        ItemView(item: item, isSelected: selectedItem == item.id, isEditing: isEditing)
                            .position(item.position)
                            .onTapGesture {
                                if isEditing {
                                    selectedItem = item.id
                                }
                            }
                            .gesture(
                                isEditing ? DragGesture()
                                    .onChanged { value in
                                        if selectedItem == item.id {
                                            var updatedItem = item
                                            updatedItem.position = value.location
                                            WidgetDataService.shared.updateHomeScreenItem(updatedItem, in: &widgetData)
                                        }
                                    } : nil
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 編集モード時のコントロール
                if isEditing {
                    HStack {
                        Button("キャンセル") {
                            isEditing = false
                            selectedItem = nil
                        }
                        Spacer()
                        Button("追加") {
                            showingAddItemSheet = true
                        }
                        Spacer()
                        if selectedItem != nil {
                            Button("削除") {
                                if let id = selectedItem {
                                    WidgetDataService.shared.removeHomeScreenItem(id: id, from: &widgetData)
                                    selectedItem = nil
                                }
                            }
                            .foregroundColor(.red)
                        }
                        Spacer()
                        Button("完了") {
                            isEditing = false
                            selectedItem = nil
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground).opacity(0.8))
                }
            }
        }
        .onLongPressGesture {
            isEditing = true
        }
        .sheet(isPresented: $showingAddItemSheet) {
            AddItemView(widgetData: $widgetData, isPresented: $showingAddItemSheet)
        }
    }
}

struct AddItemView: View {
    @Binding var widgetData: WidgetData
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var isWidget = false
    @State private var selectedWidgetType: HomeScreenItem.WidgetType = .calendar
    @State private var selectedImage = "app_icon"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("タイトル", text: $title)
                    
                    Toggle("ウィジェット", isOn: $isWidget)
                    
                    if isWidget {
                        Picker("ウィジェットタイプ", selection: $selectedWidgetType) {
                            ForEach(HomeScreenItem.WidgetType.allCases, id: \.self) { type in
                                Text(type.rawValue.capitalized)
                            }
                        }
                    } else {
                        // アイコン選択
                        Text("アイコンを選択")
                        
                        // ここにアイコン選択UIを追加
                        HStack {
                            ForEach(["app_icon", "calendar_icon", "music_icon"], id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedImage == imageName ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        selectedImage = imageName
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("アイテムを追加")
            .navigationBarItems(
                leading: Button("キャンセル") {
                    isPresented = false
                },
                trailing: Button("追加") {
                    addItem()
                    isPresented = false
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func addItem() {
        let screenSize = UIScreen.main.bounds.size
        let newItem = HomeScreenItem(
            imageName: selectedImage,
            title: title,
            position: CGPoint(x: screenSize.width / 2, y: screenSize.height / 3),
            size: CGSize(width: 80, height: 80),
            isWidget: isWidget,
            widgetType: isWidget ? selectedWidgetType : nil
        )
        
        WidgetDataService.shared.addHomeScreenItem(newItem, to: &widgetData)
    }
}

struct ItemView: View {
    let item: HomeScreenItem
    let isSelected: Bool
    let isEditing: Bool
    @EnvironmentObject var widgetData: WidgetData
    
    var body: some View {
        VStack {
            if item.isWidget {
                // ウィジェット表示
                widgetView(for: item)
            } else {
                // アイコン表示
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: item.size.width, height: item.size.height)
                    .cornerRadius(10)
                
                Text(item.title)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .frame(width: item.size.width, height: item.size.height)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .opacity(isEditing ? 0.8 : 1.0)
    }
    
    @ViewBuilder
    func widgetView(for item: HomeScreenItem) -> some View {
        if let widgetType = item.widgetType {
            switch widgetType {
            case .calendar:
                CalendarWidgetView()
                    .frame(width: item.size.width, height: item.size.height)
                    .cornerRadius(10)
            case .clock:
                ClockWidgetView()
                    .frame(width: item.size.width, height: item.size.height)
                    .cornerRadius(10)
            case .photo:
                PhotoWidgetView(imageName: item.imageName)
                    .frame(width: item.size.width, height: item.size.height)
                    .cornerRadius(10)
            case .music:
                MusicWidgetView()
                    .frame(width: item.size.width, height: item.size.height)
                    .cornerRadius(10)
            case .custom:
                if let customWidgetId = item.customWidgetId,
                   let customWidget = widgetData.customWidgets.first(where: { $0.id == customWidgetId }) {
                    CustomWidgetPreview(config: customWidget, image: nil)
                        .frame(width: item.size.width, height: item.size.height)
                        .cornerRadius(10)
                } else {
                    CustomWidgetView(title: item.title)
                        .frame(width: item.size.width, height: item.size.height)
                        .cornerRadius(10)
                }
            }
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: item.size.width, height: item.size.height)
                .cornerRadius(10)
        }
    }
}

// プレースホルダーウィジェットビュー
struct CalendarWidgetView: View {
    var body: some View {
        VStack {
            Text("カレンダー")
            Text(Date(), style: .date)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.2))
    }
}

struct ClockWidgetView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("時計")
            Text(currentTime, style: .time)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(0.2))
        .onReceive(timer) { time in
            currentTime = time
        }
    }
}

struct PhotoWidgetView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }
}

struct MusicWidgetView: View {
    var body: some View {
        VStack {
            Text("ミュージック")
            Image(systemName: "music.note")
                .font(.largeTitle)
            Text("再生中...")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple.opacity(0.2))
    }
}

struct CustomWidgetView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
            Text("カスタムウィジェット")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.opacity(0.2))
    }
}

// プレースホルダータブビュー
struct WidgetGalleryView: View {
    @Binding var widgetData: WidgetData
    @State private var showingCustomWidgetEditor = false
    @State private var editingWidget: CustomWidgetConfig?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("人気のウィジェット")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(HomeScreenItem.WidgetType.allCases, id: \.self) { type in
                                widgetPreview(for: type)
                                    .onTapGesture {
                                        addWidget(type: type)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Text("カレンダーウィジェット")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<3) { _ in
                                CalendarWidgetView()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(15)
                                    .onTapGesture {
                                        addWidget(type: .calendar)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    // カスタムウィジェットセクション
                    VStack(alignment: .leading) {
                        HStack {
                            Text("マイウィジェット")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                editingWidget = nil
                                showingCustomWidgetEditor = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        if widgetData.customWidgets.isEmpty {
                            Text("カスタムウィジェットがありません")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(widgetData.customWidgets) { widget in
                                        CustomWidgetPreview(config: widget, image: nil)
                                            .frame(width: 150, height: 150)
                                            .contextMenu {
                                                Button(action: {
                                                    editingWidget = widget
                                                    showingCustomWidgetEditor = true
                                                }) {
                                                    Label("編集", systemImage: "pencil")
                                                }
                                                
                                                Button(action: {
                                                    addWidgetToHomeScreen(widget)
                                                }) {
                                                    Label("ホーム画面に追加", systemImage: "plus.square.on.square")
                                                }
                                                
                                                Button(role: .destructive, action: {
                                                    WidgetDataService.shared.removeCustomWidget(id: widget.id, from: &widgetData)
                                                }) {
                                                    Label("削除", systemImage: "trash")
                                                }
                                            }
                                            .onTapGesture {
                                                addWidgetToHomeScreen(widget)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("ウィジェット")
            .sheet(isPresented: $showingCustomWidgetEditor) {
                CustomWidgetEditorView(
                    widgetData: $widgetData,
                    isPresented: $showingCustomWidgetEditor,
                    editingWidget: editingWidget
                )
            }
        }
    }
    
    @ViewBuilder
    func widgetPreview(for type: HomeScreenItem.WidgetType) -> some View {
        switch type {
        case .calendar:
            CalendarWidgetView()
                .frame(width: 150, height: 150)
                .cornerRadius(15)
        case .clock:
            ClockWidgetView()
                .frame(width: 150, height: 150)
                .cornerRadius(15)
        case .photo:
            PhotoWidgetView(imageName: "app_icon")
                .frame(width: 150, height: 150)
                .cornerRadius(15)
        case .music:
            MusicWidgetView()
                .frame(width: 150, height: 150)
                .cornerRadius(15)
        case .custom:
            CustomWidgetView(title: "カスタム")
                .frame(width: 150, height: 150)
                .cornerRadius(15)
        }
    }
    
    private func addWidget(type: HomeScreenItem.WidgetType) {
        let screenSize = UIScreen.main.bounds.size
        let newItem = HomeScreenItem(
            imageName: "app_icon",
            title: type.rawValue.capitalized,
            position: CGPoint(x: screenSize.width / 2, y: screenSize.height / 3),
            size: CGSize(width: 150, height: 150),
            isWidget: true,
            widgetType: type
        )
        
        WidgetDataService.shared.addHomeScreenItem(newItem, to: &widgetData)
    }
    
    private func addWidgetToHomeScreen(_ widget: CustomWidgetConfig) {
        let screenSize = UIScreen.main.bounds.size
        let newItem = HomeScreenItem(
            imageName: widget.imageName ?? "app_icon",
            title: widget.name,
            position: CGPoint(x: screenSize.width / 2, y: screenSize.height / 3),
            size: CGSize(width: 150, height: 150),
            isWidget: true,
            widgetType: .custom,
            customWidgetId: widget.id
        )
        
        WidgetDataService.shared.addHomeScreenItem(newItem, to: &widgetData)
    }
}

struct ThemeSettingsView: View {
    @Binding var widgetData: WidgetData
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("テーマ")) {
                    ForEach(widgetData.homeScreenThemes) { theme in
                        HStack {
                            Image(theme.backgroundImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                            
                            Text(theme.name)
                                .padding(.leading)
                            
                            Spacer()
                            
                            if theme.isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            WidgetDataService.shared.selectTheme(id: theme.id, in: &widgetData)
                        }
                    }
                }
                
                Section(header: Text("ウィジェットスタイル")) {
                    ForEach(WidgetStyle.allCases, id: \.self) { style in
                        HStack {
                            Text(style.name)
                            Spacer()
                            if widgetData.style == style {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            widgetData.style = style
                        }
                    }
                }
            }
            .navigationTitle("テーマ設定")
        }
    }
}

struct ProfileView: View {
    @Binding var widgetData: WidgetData
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("プロフィール")) {
                    TextField("ユーザー名", text: $widgetData.userName)
                }
                
                Section(header: Text("設定")) {
                    Toggle("ポイントを表示", isOn: $widgetData.showPoints)
                    Toggle("日付を表示", isOn: $widgetData.showDate)
                }
                
                Section(header: Text("情報")) {
                    HStack {
                        Text("ポイント")
                        Spacer()
                        Text("\(widgetData.points)")
                    }
                    
                    HStack {
                        Text("最終更新")
                        Spacer()
                        Text("\(widgetData.lastUpdated, formatter: dateFormatter)")
                    }
                    
                    Button("ポイントを増やす") {
                        widgetData.points += 100
                        widgetData.lastUpdated = Date()
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("プロフィール")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
