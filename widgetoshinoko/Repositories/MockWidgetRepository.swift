import Foundation

final class MockWidgetRepository: WidgetRepositoryProtocol {
    func fetchWidgets(category: String?) async throws -> [WidgetItem] {
        // 通信の遅延をシミュレート
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if Bool.random() && category == "error_test" {
            throw APIError.networkError(NSError(domain: "", code: -1))
        }
        
        return category == nil 
            ? MockData.widgets 
            : MockData.widgets.filter { $0.category == category }
    }
    
    func getWidget(id: UUID) async throws -> WidgetItem {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        guard let widget = MockData.widgets.first(where: { $0.id == id }) else {
            throw APIError.invalidResponse
        }
        
        return widget
    }
}
