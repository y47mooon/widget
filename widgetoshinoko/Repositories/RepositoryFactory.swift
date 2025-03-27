import Foundation
import GaudiyWidgetShared

enum RepositoryType {
    case mock
    case userDefaults
    case firebase
    case widget
}

class RepositoryFactory {
    static let shared = RepositoryFactory()
    
    private init() {}
    
    // 設定（環境に応じて適切なリポジトリを使用）
    #if DEBUG
    private var defaultType: RepositoryType = .firebase
    #elseif WIDGET_EXTENSION
    private var defaultType: RepositoryType = .widget
    #else
    private var defaultType: RepositoryType = .firebase
    #endif
    
    func setDefaultType(_ type: RepositoryType) {
        defaultType = type
    }
    
    func makeClockPresetRepository() -> ClockPresetRepository {
        switch defaultType {
        case .mock:
            // MockClockPresetRepositoryは後で実装するか、簡略化
            return GaudiyWidgetShared.WidgetClockPresetRepository()
        case .userDefaults:
            // ClockPresetRepositoryImplは後で実装するか、簡略化
            return GaudiyWidgetShared.WidgetClockPresetRepository()
        case .firebase:
            #if canImport(FirebaseFirestore)
            return FirebaseClockPresetRepository()
            #else
            return GaudiyWidgetShared.WidgetClockPresetRepository()
            #endif
        case .widget:
            // 明示的に共有フレームワークのクラスを使用
            return GaudiyWidgetShared.WidgetClockPresetRepository()
        }
    }
    
    func makeFirestoreRepository() -> FirestoreRepositoryProtocol {
        switch defaultType {
        case .mock, .userDefaults, .firebase:
            #if canImport(FirebaseFirestore)
            return FirestoreRepository()
            #else
            // WidgetFirestoreRepositoryの代わりにダミー実装
            return createMockFirestoreRepository()
            #endif
        case .widget:
            // WidgetFirestoreRepositoryの代わりにダミー実装
            return createMockFirestoreRepository()
        }
    }
    
    // ダミーのFirestoreRepositoryを作成
    private func createMockFirestoreRepository() -> FirestoreRepositoryProtocol {
        // 簡単なダミー実装
        class MockFirestoreRepository: FirestoreRepositoryProtocol {
            func fetchContents(category: String, limit: Int) async throws -> [FirebaseContentItem] {
                return []
            }
            
            func saveContent(_ content: FirebaseContentItem) async throws {
                // 何もしない
            }
            
            func updateContent(_ content: FirebaseContentItem) async throws {
                // 何もしない
            }
            
            func deleteContent(id: String) async throws {
                // 何もしない
            }
            
            func fetchCurrentUser() async throws -> User? {
                return nil
            }
            
            func createUser(email: String, password: String) async throws -> User {
                return User(id: "mock-id", name: "Mock User")
            }
            
            func signIn(email: String, password: String) async throws -> User {
                return User(id: "mock-id", name: "Mock User")
            }
            
            func signOut() async throws {
                // 何もしない
            }
            
            func fetchUserContents(userId: String) async throws -> [UserContent] {
                return []
            }
            
            func saveUserContent(_ userContent: UserContent) async throws {
                // 何もしない
            }
            
            func fetchPayments(userId: String) async throws -> [Payment] {
                return []
            }
            
            func savePayment(_ payment: Payment) async throws {
                // 何もしない
            }
        }
        
        return MockFirestoreRepository()
    }
}
