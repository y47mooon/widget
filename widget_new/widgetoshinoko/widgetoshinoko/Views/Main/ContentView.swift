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
    @State private var showingCreateMenu = false
    @State private var selectedCreationType: WidgetCreationType?
    @State private var selectedCategory: Int = 0
    @State private var previousTab: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                MainContent()
                    .tabItem {
                        CustomTabItem(
                            imageName: "house",
                            text: "ホーム",
                            isSelected: selectedTab == 0
                        )
                    }
                    .tag(0)
                
                SearchView()
                    .tabItem {
                        CustomTabItem(
                            imageName: "magnifyingglass",
                            text: "検索",
                            isSelected: selectedTab == 1
                        )
                    }
                    .tag(1)
                
                Color.clear
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                            .environment(\.symbolVariants, .fill)
                        Text("作成")
                    }
                    .tag(2)
                
                FavoritesView()
                    .tabItem {
                        CustomTabItem(
                            imageName: "heart.fill",
                            text: "お気に入り",
                            isSelected: selectedTab == 3
                        )
                    }
                    .tag(3)
                
                MyPageView()
                    .tabItem {
                        CustomTabItem(
                            imageName: "person.fill",
                            text: "マイページ",
                            isSelected: selectedTab == 4
                        )
                    }
                    .tag(4)
            }
            .tint(.pink)
            .edgesIgnoringSafeArea(.bottom)
            .onChange(of: selectedTab) { newValue in
                if newValue == 2 {
                    showingCreateMenu = true
                    selectedTab = previousTab
                } else {
                    previousTab = newValue
                }
            }
        }
        .sheet(isPresented: $showingCreateMenu) {
            CreateMenuView(
                isPresented: $showingCreateMenu,
                selectedCreationType: $selectedCreationType
            )
            .presentationDetents([.height(400)])
        }
        .onChange(of: selectedCreationType) { newValue in
            if let type = newValue {
                print("Selected type: \(type)")
                selectedCreationType = nil
            }
        }
    }
}

#Preview {
    ContentView()
}