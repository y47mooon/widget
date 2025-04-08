import SwiftUI
import GaudiyWidgetShared

/// テンプレート画面のコンテンツビュー
struct TemplateContentView: View {
    @StateObject private var templateViewModel = TemplateViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // 注目のテンプレート
                featuredSection
                
                // カテゴリー別テンプレート
                ForEach(TemplateCategory.allCases, id: \.self) { category in
                    if let templates = templateViewModel.templatesByCategory[category], !templates.isEmpty {
                        templateSection(category: category, templates: templates)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
            }
            .padding(.bottom, 16)
        }
        .task {
            await templateViewModel.loadTemplates()
        }
    }
    
    // 注目のテンプレートセクション
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("template_featured".localized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // 注目のテンプレートカルーセル
            TabView {
                ForEach(getFeaturedTemplates(), id: \.id) { template in
                    FeaturedTemplateView(template: template)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
    
    // カテゴリー別テンプレートセクション
    private func templateSection(category: TemplateCategory, templates: [TemplateItem]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(category.localizedTitle.localized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                NavigationLink(destination: TemplateCategoryView(category: category, viewModel: templateViewModel)) {
                    Text("button_see_more".localized)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            
            // テンプレート横スクロール
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(templates, id: \.id) { template in
                        NavigationLink(destination: TemplateSimplePreviewView(template: template)) {
                            templateItemView(for: template)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // テンプレートアイテムビュー
    private func templateItemView(for template: TemplateItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: template.imageUrl)) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 160)
            
            Text(template.title)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(width: 120, alignment: .leading)
        }
    }
    
    // 注目のテンプレートを取得
    private func getFeaturedTemplates() -> [TemplateItem] {
        // 各カテゴリから一つずつ取得
        var featured: [TemplateItem] = []
        
        for category in TemplateCategory.allCases {
            if let templates = templateViewModel.templatesByCategory[category], 
               let first = templates.first {
                featured.append(first)
            }
        }
        
        return featured.isEmpty ? templateViewModel.allTemplates.prefix(3).map { $0 } : featured
    }
}

// 注目のテンプレート表示用ビュー
struct FeaturedTemplateView: View {
    let template: TemplateItem
    
    var body: some View {
        NavigationLink(destination: TemplateSimplePreviewView(template: template)) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: template.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // テンプレート情報
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(template.category.localizedTitle.localized)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
    }
}

// カテゴリー別テンプレート表示画面
struct TemplateCategoryView: View {
    let category: TemplateCategory
    @ObservedObject var viewModel: TemplateViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(templates, id: \.id) { template in
                    NavigationLink(destination: TemplateSimplePreviewView(template: template)) {
                        templateGridItemView(for: template)
                    }
                }
            }
            .padding()
            
            // ページネーション
            if viewModel.hasMoreTemplates(for: category) {
                Button(action: {
                    Task {
                        currentPage += 1
                        await viewModel.loadMoreTemplates(for: category, page: currentPage)
                    }
                }) {
                    Text("button_load_more".localized)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(category.localizedTitle.localized)
    }
    
    private var templates: [TemplateItem] {
        viewModel.templatesByCategory[category] ?? []
    }
    
    private func templateGridItemView(for template: TemplateItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: template.imageUrl)) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .aspectRatio(3/4, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(template.title)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}

// プレビュー
#Preview {
    NavigationView {
        TemplateContentView()
    }
}
