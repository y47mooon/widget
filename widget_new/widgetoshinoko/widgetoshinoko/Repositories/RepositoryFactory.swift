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
    
    // シングルトンの保持
    private var repositories: [String: Any] = [:]
    
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
        // キャッシュ対応
        let key = "ClockPresetRepository"
        if let cached = repositories[key] as? ClockPresetRepository {
            return cached
        }
        
        let repo: ClockPresetRepository
        switch defaultType {
        case .mock:
            repo = GaudiyWidgetShared.WidgetClockPresetRepository()
        case .userDefaults:
            repo = GaudiyWidgetShared.WidgetClockPresetRepository()
        case .firebase:
            #if canImport(FirebaseFirestore)
            repo = FirebaseClockPresetRepository()
            #else
            repo = GaudiyWidgetShared.WidgetClockPresetRepository()
            #endif
        case .widget:
            repo = GaudiyWidgetShared.WidgetClockPresetRepository()
        }
        
        // キャッシュに保存
        repositories[key] = repo
        return repo
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
