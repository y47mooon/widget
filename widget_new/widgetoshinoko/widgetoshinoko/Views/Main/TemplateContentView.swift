import SwiftUI
import GaudiyWidgetShared

struct TemplateContentView: View {
    @ObservedObject var mainViewModel: MainContentViewModel
    @StateObject private var viewModel = TemplateViewModel()
    
    init(viewModel: MainContentViewModel) {
        self.mainViewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // 特集セクション
                featuredSection
                
                // カテゴリーセクション
                ForEach(TemplateCategory.allCases, id: \.self) { category in
                    templateSection(for: category)
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("テンプレート".localized)
    }
    
    // 特集テンプレートセクション
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("featured_templates".localized)
                .font(.headline)
                .padding(.leading)
            
            // 特集テンプレートカルーセル
            TabView {
                ForEach(getFeaturedTemplates(), id: \.id) { template in
                    NavigationLink(destination: TemplatePreviewView(template: template, contentId: template.id)) {
                        FeaturedTemplateView(template: template)
                    }
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
    
    // カテゴリー別テンプレートセクション
    private func templateSection(for category: TemplateCategory) -> some View {
        let templates = viewModel.loadTemplates(for: category)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(category.displayName)
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(
                    destination: TemplateCategoryView(category: category)
                ) {
                    HStack {
                        Text("button_see_more".localized)
                            .font(.system(size: 14))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            // 水平スクロールでテンプレート表示
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(templates.prefix(6)) { template in
                        NavigationLink(
                            destination: TemplatePreviewView(template: template, contentId: template.id)
                        ) {
                            TemplateItemView(item: template)
                                .frame(width: 140)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
    }
    
    // 特集テンプレート用のサンプルデータを取得
    private func getFeaturedTemplates() -> [TemplateItem] {
        var featuredTemplates: [TemplateItem] = []
        
        // 各カテゴリから1つずつ特集として表示
        for category in TemplateCategory.allCases {
            if let firstTemplate = viewModel.loadTemplates(for: category).first {
                featuredTemplates.append(firstTemplate)
            }
        }
        
        return featuredTemplates.prefix(5).map { $0 }
    }
}

// 特集テンプレートビュー
struct FeaturedTemplateView: View {
    let template: TemplateItem
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 背景画像
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    // 実際の画像を表示（または、カテゴリに基づいた代替表示）
                    Group {
                        if !template.imageUrl.isEmpty && template.imageUrl != "dummy_url" {
                            AsyncImage(url: URL(string: template.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            // カテゴリに基づいた代替表示
                            let color: Color = {
                                switch template.category {
                                case .minimal: return .gray
                                case .simple: return .blue
                                case .stylish: return .purple
                                case .new: return .green
                                case .recommended: return .orange
                                case .seasonal: return .pink
                                case .popular: return .red
                                }
                            }()
                            
                            color.opacity(0.6)
                                .overlay(
                                    VStack {
                                        Image(systemName: "square.grid.2x2")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                        Text(template.category.displayName)
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    }
                                )
                        }
                    }
                )
            
            // テンプレート情報オーバーレイ
            VStack(alignment: .leading, spacing: 4) {
                Text(template.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(template.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .top
            ))
        }
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// カテゴリー別テンプレート一覧画面
struct TemplateCategoryView: View {
    let category: TemplateCategory
    @StateObject private var viewModel: TemplateCategoryViewModel
    
    init(category: TemplateCategory) {
        self.category = category
        self._viewModel = StateObject(wrappedValue: TemplateCategoryViewModel(category: category))
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 160), spacing: 16)
                ],
                spacing: 16
            ) {
                // テンプレート一覧
                templatesContent
                
                // ローディングインジケータ
                loadingIndicator
            }
            .padding()
        }
        .navigationTitle(category.displayName)
    }
    
    // テンプレート一覧部分を分離
    private var templatesContent: some View {
        ForEach(viewModel.templates) { template in
            templateLink(for: template)
        }
    }
    
    // 個別のテンプレートリンクを生成する関数
    private func templateLink(for template: TemplateItem) -> some View {
        NavigationLink(
            destination: TemplatePreviewView(template: template, contentId: template.id)
        ) {
            TemplateItemView(item: template)
                .onAppear {
                    checkForMoreContent(template: template)
                }
        }
    }
    
    // ロード処理を個別のメソッドに分離
    private func checkForMoreContent(template: TemplateItem) {
        if template.id == viewModel.templates.last?.id {
            viewModel.loadNextPage()
        }
    }
    
    // ローディングインジケータ部分を分離
    private var loadingIndicator: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
}

// テンプレートアイテムビュー
struct TemplateItemView: View {
    let item: TemplateItem
    
    var body: some View {
        VStack {
            ZStack {
                // 背景画像またはカテゴリに基づいた代替表示
                if !item.imageUrl.isEmpty && item.imageUrl != "dummy_url" {
                    AsyncImage(url: URL(string: item.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            categoryPlaceholder
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .aspectRatio(3/4, contentMode: .fit)
                    .clipped()
                    .cornerRadius(12)
                } else {
                    categoryPlaceholder
                }
            }
            .frame(height: 180)
            
            Text(item.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // カテゴリ別プレースホルダー
    private var categoryPlaceholder: some View {
        let color: Color = {
            switch item.category {
            case .minimal: return .gray
            case .simple: return .blue
            case .stylish: return .purple
            case .new: return .green
            case .recommended: return .orange
            case .seasonal: return .pink
            case .popular: return .red
            }
        }()
        
        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.3))
            
            VStack(spacing: 8) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(item.category.displayName)
                    .font(.caption)
                    .foregroundColor(color)
            }
        }
    }
}

// プレビュー
struct TemplateContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TemplateContentView(viewModel: MainContentViewModel())
        }
    }
}
