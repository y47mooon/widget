import Foundation
import GaudiyWidgetShared

public protocol FirestoreRepositoryProtocol {
    // コンテンツ関連
    func fetchContents(category: String, limit: Int) async throws -> [FirebaseContentItem]
    func saveContent(_ content: FirebaseContentItem) async throws
    func updateContent(_ content: FirebaseContentItem) async throws
    func deleteContent(id: String) async throws
    
    // ユーザー関連
    func fetchCurrentUser() async throws -> User?
    func createUser(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    
    // ユーザーコンテンツ関連
    func fetchUserContents(userId: String) async throws -> [UserContent]
    func saveUserContent(_ userContent: UserContent) async throws
    
    // 支払い関連
    func fetchPayments(userId: String) async throws -> [Payment]
    func savePayment(_ payment: Payment) async throws
}
