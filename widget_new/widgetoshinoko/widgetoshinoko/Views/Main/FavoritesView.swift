//
//  FavoritesView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//
import SwiftUI
import Foundation // もし必要な場合

struct FavoritesView: View {
    @State private var selectedCategory: Int = 0
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // 検索バー
            CustomSearchBar(searchText: $searchText)
            
            // カテゴリー
            CategoryScrollView(
                selectedCategory: $selectedCategory,
                categories: AppConstants.categories
            )
            
            // コンテンツエリア
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(0..<10) { _ in
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    struct SearchView: View {
        @State private var selectedCategory: Int = 0
        
        var body: some View {
            VStack {
                // カテゴリー選択部分
                CategoryScrollView(
                    selectedCategory: $selectedCategory,
                    categories: AppConstants.categories
                )
                // ... 残りの実装
            }
        }
    }
}

#Preview {
    FavoritesView()
}