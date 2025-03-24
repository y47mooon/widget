import SwiftUI

struct FilterTagsScrollView: View {
    @Binding var selectedTag: String
    let tags: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    FilterChipView(
                        title: tag,
                        isSelected: selectedTag == tag,
                        action: {
                            selectedTag = tag
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

// AppConstantsのフィルタータグを使う場合のプレビュー
#Preview {
    FilterTagsScrollView(
        selectedTag: .constant("シンプル"),
        tags: AppConstants.topFilterTags
    )
}
