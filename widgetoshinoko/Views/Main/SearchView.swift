//
//  SearchView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//
import SwiftUI
import Foundation

struct SearchView: View {
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
}

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("検索", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}