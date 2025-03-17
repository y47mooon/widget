import Foundation
import SwiftUI

@MainActor
final class WidgetListViewModel: ObservableObject {
    @Published private(set) var widgets: [WidgetItem] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let repository: WidgetRepositoryProtocol
    
    nonisolated init(repository: WidgetRepositoryProtocol = MockWidgetRepository()) {
        self.repository = repository
    }
    
    func loadWidgets(category: String? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            widgets = try await repository.fetchWidgets(category: category)
        } catch let error as APIError {
            errorMessage = error.errorDescription
            // 開発時はエラーの詳細を出力
            #if DEBUG
            print("Error: \(error)")
            #endif
        } catch {
            errorMessage = "予期せぬエラーが発生しました"
        }
        
        isLoading = false
    }
    
    func applySortOrder(_ order: SortOrder) {
        withAnimation {
            switch order {
            case .popular:
                widgets.sort { $0.popularity > $1.popularity }
            case .newest:
                widgets.sort { $0.createdAt > $1.createdAt }
            case .oldest:
                widgets.sort { $0.createdAt < $1.createdAt }
            }
        }
    }
}
