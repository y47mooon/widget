import Foundation

protocol ContentRepositoryProtocol {
    func fetchItems<Category: CategoryType>(
        category: Category?,
        limit: Int
    ) async throws -> [ContentItem<Category>]
}

class MockContentRepository: ContentRepositoryProtocol {
    func fetchItems<Category: CategoryType>(
        category: Category?,
        limit: Int = 5
    ) async throws -> [ContentItem<Category>] {
        // モックデータを生成
        return (0..<limit).map { index in
            ContentItem(
                title: "Item \(index + 1)",
                imageUrl: "mock_image_\(index)",
                category: category ?? Category.allCases[0],
                popularity: Int.random(in: 0...100)
            )
        }
    }
}
