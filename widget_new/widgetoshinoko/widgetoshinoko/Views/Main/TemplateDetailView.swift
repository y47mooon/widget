//
//  TemplateDetailView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//

import Foundation
import SwiftUI
import GaudiyWidgetShared

// ViewModel部分はViewModel/TemplateViewModel.swiftで定義されているものを使用

// テンプレート詳細画面
struct TemplateDetailView: View {
    let template: TemplateItem
    let contentId: UUID
    @StateObject private var viewModel = TemplateDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // プレビュー表示はTemplatePreviewViewで実装済みのため、
                // このビューはダミー表示または削除候補とします
                Text("このビューは非推奨です。代わりにTemplatePreviewViewを使用してください。")
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
                
                Text("テンプレート詳細画面")
                    .font(.headline)
                
                Text(template.title)
                    .font(.title)
                
                if let description = template.description {
                    Text(description)
                        .font(.body)
                }
            }
            .padding()
        }
        .navigationTitle("テンプレート詳細")
        .onAppear {
            viewModel.loadTemplate(id: contentId)
        }
    }
}

// プレビュー
struct TemplateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TemplateDetailView(
                template: TemplateItem(
                    id: UUID(),
                    title: "テストテンプレート",
                    imageUrl: ""
                ),
                contentId: UUID()
            )
        }
    }
}
