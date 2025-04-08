//
//  TemplateDetailView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//

import Foundation
import SwiftUI
import GaudiyWidgetShared

/// テンプレート詳細画面
struct TemplateDetailView: View {
    let template: TemplateItem
    let contentId: UUID
    @StateObject private var viewModel = TemplateDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if let detailTemplate = viewModel.template {
                    // ヘッダー画像
                    AsyncImage(url: URL(string: detailTemplate.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 250)
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 250)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    // テンプレート情報
                    VStack(alignment: .leading, spacing: 16) {
                        Text(detailTemplate.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let description = detailTemplate.description {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // カテゴリータグ
                        HStack {
                            Text(detailTemplate.category.localizedTitle.localized)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(16)
                            
                            Spacer()
                            
                            // 人気度
                            Label("\(detailTemplate.popularity)", systemImage: "heart.fill")
                                .font(.caption)
                                .foregroundColor(.pink)
                        }
                        
                        Divider()
                        
                        // 使用方法セクション
                        VStack(alignment: .leading, spacing: 12) {
                            Text("template_how_to_use".localized)
                                .font(.headline)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HowToUseStep(number: 1, text: "template_step_download".localized)
                                HowToUseStep(number: 2, text: "template_step_apply".localized)
                                HowToUseStep(number: 3, text: "template_step_customize".localized)
                            }
                        }
                        
                        Divider()
                        
                        // アクションボタン
                        VStack(spacing: 12) {
                            Button(action: {
                                // 壁紙のダウンロードなどのアクション
                            }) {
                                Label("template_download_wallpaper".localized, systemImage: "arrow.down.circle")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                // ウィジェットのダウンロードなどのアクション
                            }) {
                                Label("template_get_widgets".localized, systemImage: "square.grid.2x2")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                } else if let error = viewModel.error {
                    // エラー表示
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                            .padding()
                        
                        Text("読み込みエラー")
                            .font(.headline)
                        
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("再読み込み") {
                            viewModel.loadTemplate(id: contentId)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                } else {
                    // 初期データを表示
                    VStack(alignment: .leading, spacing: 16) {
                        Text(template.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let description = template.description {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // 読み込み中表示
                        Text("詳細を読み込み中...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("テンプレート詳細")
        .onAppear {
            viewModel.loadTemplate(id: contentId)
        }
    }
}

/// 使用方法のステップ表示用ビュー
struct HowToUseStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 28, height: 28)
                
                Text("\(number)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
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
                    description: "これはテスト用のテンプレート説明文です。",
                    imageUrl: "https://picsum.photos/400/600",
                    category: .popular,
                    popularity: 250
                ),
                contentId: UUID()
            )
        }
    }
}
