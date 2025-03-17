//
//  TemplateDetailView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//

import Foundation
import SwiftUI

// テンプレートアイテムのモデル
struct TemplateItem: Identifiable {
    let id: UUID
    let imageUrl: String
    let title: String
    let category: TemplateCategory  // ContentTypes.swiftで定義されているenumを使用
    // 必要に応じて他のプロパティを追加
}

// TemplateViewModelの追加
class TemplateViewModel: ObservableObject {
    @Published var itemsByCategory: [TemplateCategory: [TemplateItem]] = [:]
    
    func loadInitialData() {
        // テストデータの生成
        for category in TemplateCategory.allCases {
            itemsByCategory[category] = (0..<4).map { index in
                TemplateItem(
                    id: UUID(),
                    imageUrl: "dummy_url",
                    title: "\(category.rawValue) \(index + 1)",
                    category: category
                )
            }
        }
    }
}

// テンプレート詳細画面
struct TemplateDetailView: View {
    let title: String
    @StateObject private var viewModel = TemplateViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // 各カテゴリーセクション
                ForEach(TemplateCategory.allCases, id: \.self) { category in
                    TemplateSectionView(
                        category: category,
                        items: viewModel.itemsByCategory[category] ?? []
                    )
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            viewModel.loadInitialData()
        }
    }
}

// カテゴリーセクションビュー
struct TemplateSectionView: View {
    let category: TemplateCategory
    let items: [TemplateItem]
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // ヘッダー
            HStack {
                Text(category.rawValue)
                    .font(.headline)
                Spacer()
                if !isExpanded {
                    NavigationLink(
                        destination: TemplateListView(category: category)
                    ) {
                        HStack {
                            Text("もっと見る")
                                .font(.system(size: 14))
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            
            // コンテンツ
            if !isExpanded {
                // 横スクロールビュー（プレビュー用）
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(items.prefix(4)) { item in
                            TemplateItemView(item: item)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// テンプレート一覧画面（もっと見る押下時）
struct TemplateListView: View {
    let category: TemplateCategory
    @StateObject private var viewModel = TemplateListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ForEach(viewModel.items) { item in
                    TemplateItemView(item: item)
                        .onAppear {
                            // 最後のアイテムが表示されたら追加データを読み込む
                            if item.id == viewModel.items.last?.id {
                                viewModel.loadMoreItems()
                            }
                        }
                }
                
                // ローディングインジケータ
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .onAppear {
            viewModel.loadInitialData(category: category)
        }
    }
}

// ビューモデル
class TemplateListViewModel: ObservableObject {
    @Published var items: [TemplateItem] = []
    @Published var isLoading = false
    private var currentPage = 0
    private var hasMorePages = true
    
    func loadInitialData(category: TemplateCategory) {
        guard items.isEmpty else { return }
        loadMoreItems()
    }
    
    func loadMoreItems() {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        
        // ここでAPI呼び出しや非同期データ取得を実装
        // 例: ページネーションを使用したデータ取得
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // シミュレーション用
            // テストデータの追加（実際のAPIレスポンスに置き換え）
            let newItems = (0..<10).map { _ in
                TemplateItem(
                    id: UUID(),
                    imageUrl: "dummy_url",
                    title: "Template \(self.items.count + 1)",
                    category: .popular
                )
            }
            
            self.items.append(contentsOf: newItems)
            self.currentPage += 1
            self.hasMorePages = self.currentPage < 5 // 例: 最大5ページまで
            self.isLoading = false
        }
    }
}

// テンプレートアイテムビュー
struct TemplateItemView: View {
    let item: TemplateItem
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 280)
            // 実際の画像を表示する場合は AsyncImage を使用
            
            Text(item.title)
                .lineLimit(1)
        }
    }
}
