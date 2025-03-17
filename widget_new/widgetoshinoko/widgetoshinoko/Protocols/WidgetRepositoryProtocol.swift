import Foundation

protocol WidgetRepositoryProtocol {
    func fetchWidgets(category: String?) async throws -> [WidgetItem]
    func getWidget(id: UUID) async throws -> WidgetItem
}
