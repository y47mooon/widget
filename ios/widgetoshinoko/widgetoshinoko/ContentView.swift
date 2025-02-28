//
//  ContentView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/02/26.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var userName: String = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")?.string(forKey: "userName") ?? "ゲスト"
    @State private var points: Int = UserDefaults(suiteName: "group.gaudy.widgetoshinoko")?.integer(forKey: "points") ?? 0
    @State private var selectedTheme: WidgetTheme = .light
    @State private var selectedStyle: WidgetStyle = .standard
    @State private var showPoints: Bool = true
    @State private var showDate: Bool = true
    @State private var selectedTab = 0
    
    func updateWidgetData() {
        let widgetData = WidgetData(
            userName: userName,
            points: points,
            lastUpdated: Date(),
            theme: selectedTheme,
            style: selectedStyle,
            showPoints: showPoints,
            showDate: showDate
        )
        
        if let encoded = try? JSONEncoder().encode(widgetData) {
            UserDefaults(suiteName: "group.gaudy.widgetoshinoko")?.set(encoded, forKey: "widgetData")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // プロフィールタブ
            NavigationView {
                VStack(spacing: 20) {
                    Text("プロフィール")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ユーザー名")
                            .font(.headline)
                        TextField("ユーザー名を入力", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        
                        Text("ポイント")
                            .font(.headline)
                        HStack {
                            Button(action: {
                                points -= 100
                                updateWidgetData()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            
                            Text("\(points)")
                                .font(.title)
                                .frame(minWidth: 100)
                            
                            Button(action: {
                                points += 100
                                updateWidgetData()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("プロフィール")
            }
            .tag(0)
            
            // カスタマイズタブ
            NavigationView {
                Form {
                    Section(header: Text("テーマ")) {
                        ForEach(WidgetTheme.allCases, id: \.self) { theme in
                            HStack {
                                Circle()
                                    .fill(theme.backgroundColor)
                                    .frame(width: 20, height: 20)
                                Text(theme.name)
                                Spacer()
                                if selectedTheme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTheme = theme
                                updateWidgetData()
                            }
                        }
                    }
                    
                    Section(header: Text("スタイル")) {
                        ForEach(WidgetStyle.allCases, id: \.self) { style in
                            HStack {
                                Text(style.name)
                                Spacer()
                                if selectedStyle == style {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedStyle = style
                                updateWidgetData()
                            }
                        }
                    }
                    
                    Section(header: Text("表示設定")) {
                        Toggle("ポイントを表示", isOn: $showPoints)
                            .onChange(of: showPoints) { _ in updateWidgetData() }
                        Toggle("更新日時を表示", isOn: $showDate)
                            .onChange(of: showDate) { _ in updateWidgetData() }
                    }
                }
                .navigationTitle("カスタマイズ")
            }
            .tabItem {
                Image(systemName: "paintbrush")
                Text("カスタマイズ")
            }
            .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
