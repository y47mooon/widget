//
//  ContentView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/02.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedCategory = 0
    @State private var showCreateMenu = false
    @State private var selectedCreationType: WidgetCreationType?
    
    let categories = ["全て", "テンプレート", "ウィジェット", "アイコン", "壁紙", "ロック画面"]
    let filterTags = ["おしゃれ", "シンプル", "白", "モノクロ", "かわいい", "きれい"]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // ホームタブ
            MainContentView(selectedCategory: $selectedCategory, 
                          categories: categories, 
                          filterTags: filterTags)
            .tabItem {
                Image(systemName: "house")
                Text("ホーム")
            }
            .tag(0)
            
            // 作成タブ
            Button(action: { showCreateMenu = true }) {
                Image(systemName: "plus.circle.fill")
                Text("作成")
            }
            .tabItem {
                Image(systemName: "plus.circle")
                Text("作成")
            }
            .tag(1)
            
            // 設定タブ
            Text("設定")
                .tabItem {
                    Image(systemName: "gear")
                    Text("設定")
                }
                .tag(2)
        }
        .fullScreenCover(isPresented: $showCreateMenu) {
            CreateMenuView(isPresented: $showCreateMenu, 
                         selectedCreationType: $selectedCreationType)
        }
        .sheet(item: $selectedCreationType) { type in
            switch type {
            case .widget:
                WidgetCreationView()
            case .icon:
                Text("アイコン作成")
            case .template:
                Text("テンプレート作成")
            case .lockScreen:
                Text("ロック画面作成")
            case .liveWallpaper:
                Text("ライブ壁紙作成")
            case .cancel:
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
