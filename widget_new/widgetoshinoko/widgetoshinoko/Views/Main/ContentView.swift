//
//  ContentView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/02.
//

import SwiftUI

struct CustomTabItem: View {
    let imageName: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 24))
            if isSelected {
                Text(text)
                    .font(.system(size: 10))
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var selectedCategory: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainContent()
                .tabItem {
                    CustomTabItem(
                        imageName: "house",
                        text: "tab_home".localized,
                        isSelected: selectedTab == 0
                    )
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    CustomTabItem(
                        imageName: "magnifyingglass",
                        text: "tab_search".localized,
                        isSelected: selectedTab == 1
                    )
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    CustomTabItem(
                        imageName: "heart.fill",
                        text: "tab_favorites".localized,
                        isSelected: selectedTab == 2
                    )
                }
                .tag(2)
            
            MyPageView()
                .tabItem {
                    CustomTabItem(
                        imageName: "person.fill",
                        text: "tab_mypage".localized,
                        isSelected: selectedTab == 3
                    )
                }
                .tag(3)
        }
        .tint(.pink)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            print("\n===================================")
            print("📲 ContentView表示 📲")
            print("===================================\n")
            
            // 画面表示のアナリティクスイベントを送信
            AnalyticsService.shared.logScreenView("ContentView", screenClass: "ContentView")
        }
    }
}

#Preview {
    ContentView()
}